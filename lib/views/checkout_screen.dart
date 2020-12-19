import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/add_order_bloc.dart';
import 'package:charliechang/blocs/apply_coupon_bloc.dart';
import 'package:charliechang/blocs/apply_loyalty_bloc.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/blocs/loyalty_points_bloc.dart';
import 'package:charliechang/blocs/online_payment_bloc.dart';
import 'package:charliechang/blocs/provider.dart';
import 'package:charliechang/blocs/redeem_otp_bloc.dart';
import 'package:charliechang/models/add_order_response_model.dart';
import 'package:charliechang/models/apply_coupon_response.dart';
import 'package:charliechang/models/apply_loyalty_response.dart';
import 'package:charliechang/models/get_loyalty_points_dropdown.dart';
import 'package:charliechang/models/loyalty_dropdown.dart';
import 'package:charliechang/models/loyalty_points_response.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/online_payment_response.dart';
import 'package:charliechang/models/order_model.dart';
import 'package:charliechang/models/redeem_otp_response.dart';
import 'package:charliechang/models/special_offers_model.dart';
import 'package:charliechang/networking/ApiProvider.dart';
import 'package:charliechang/networking/CustomException.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/pay_screen.dart';
import 'package:charliechang/views/payment_fail_screen.dart';
import 'package:charliechang/views/pickup_address_screen.dart';
import 'package:charliechang/views/thanks_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://flutter.io';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class PayScreen extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => const CheckoutScreen(),
          '/widget': (_) {
            return SafeArea(
              child: WebviewScaffold(
                url: selectedUrl,
                javascriptChannels: jsChannels,
                mediaPlaybackRequiresUserGesture: false,
                appBar: AppBar(
                  title: const Text(''),
                ),
                withZoom: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                    height: getHeight(context),
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )),
              ),
            );
          },
        },
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen();

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //int itemTotal=0;
  List<Menu> orderModelList = new List();
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  final controllerCoupon = TextEditingController();
  final controllerRedeem = TextEditingController();
  final controllerComment = TextEditingController();

  void onConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      setState(() {
        _isInternetAvailable = false;
      });
    } else {
      setState(() {
        _isInternetAvailable = true;
      });
    }
  }

  CartProvider provider = new CartProvider();
  bool isWebviewopen = false;
  String pickup_delivery;
  final _pinEditingController = TextEditingController();
  bool isRedeemCalled = false;

  static final data = {
    "id": 1,
    "points": 2050,
    "select_points": {
      "11744": "200 ( 2000 Loyalty points )",
      "11745": "200 ( 2000 Loyalty points )"
    }
  };

  String reward_id_selected = "";
  List _dates = [];
  List _special_offers = [];
  bool isEmpty = false;
  bool isPaymentFail = false;
  bool isSuccessApiCalled = false;
  bool isPointsCalled = true;
  String loyalty_discount = "";

  @override
  void initState() {
    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
      }
    });

    getOrderType();
    print("CART COUNT ${bloc.getCartValue()}");
    _connectivity = new Connectivity();
    _subscription =
        _connectivity.onConnectivityChanged.listen(onConnectivityChange);

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("URLLL after change is $url");
      if (mounted) {
        if (url.contains('${ApiProvider.BASE_URL_FOR_WEB}thankyou')) {
          Uri uri = Uri.parse(url);
          //Take the payment_id parameter of the url.
          String paymentRequestId = uri.queryParameters['payment_id'];
          //calling this method to check payment status
          print("calling this method to check payment status $paymentRequestId");

          _checkPaymentStatus(
              id: paymentRequestId, reward_id_selected: reward_id_selected);
        } else {
          print("ELSE");
        }
      }
    });

    if (dropdownValueReedem == "Redeem CC Points") {
      if (_isInternetAvailable) {
        if (isPointsCalled) {
          setState(() {
            isPointsCalled = false;
          });
          callPointsAPI();
          callDropdownAPI();
        }
      } else
        CommonMethods.showLongToast(CHECK_INTERNET);
    }

    super.initState();
  }

  int total = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

// On destroy stream
  StreamSubscription _onDestroy;

  @override
  void dispose() {
    _onDestroy.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: isWebviewopen ? exitPayDialog : goBack,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: isEmpty || isPaymentFail
              ? PreferredSize(
                  child: Container(
                    height: 0,
                  ),
                  preferredSize: Size.fromHeight(0))
              : pickup_delivery == "1" ? deliveryAppBar() : pickupAppBar(),
          bottomNavigationBar: isEmpty || isPaymentFail
              ? Container(
                  height: 0,
                )
              : bottomUI(),
          body: SingleChildScrollView(
            child: Container(
              width: getWidth(context),
              child: isPaymentFail
                  ? paymentFail()
                  : isEmpty
                      ? EmptyCart()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CommonMethods().thickHorizontalLine(context),
                            StreamBuilder(
                              stream: bloc.listStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  orderModelList = snapshot.data;
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: orderModelList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        int price = int.parse(
                                                orderModelList[index].price) *
                                            orderModelList[index].count;
                                        int itemTotal = 0;
                                        itemTotal = itemTotal +
                                            int.parse(orderModelList[index]
                                                    .price) *
                                                orderModelList[index].count;
                                        total = itemTotal;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30.0, right: 30.0),
                                          child: Container(
                                            width: getWidth(context),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                        "${orderModelList[index].name}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                notification_title_color)),
                                                    width:
                                                        getWidth(context) / 2 -
                                                            70,
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: button_color,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    3.3))),
                                                    child: Row(
                                                      children: <Widget>[
                                                        orderModelList[index]
                                                                    .count >
                                                                0
                                                            ? IconButton(
                                                                icon: Icon(
                                                                  Icons.remove,
                                                                  color:
                                                                      button_color,
                                                                  size: 15,
                                                                ),
                                                                onPressed: () {
                                                                  if (orderModelList[
                                                                              index]
                                                                          .count !=
                                                                      1) {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          "REMOVE ITEM ${bloc.getCartValue()}  $minCouponValue");
                                                                      orderModelList[
                                                                              index]
                                                                          .count--;
                                                                    });
                                                                    if (bloc.getCartValue() <
                                                                            minCouponValue ||
                                                                        isCouponApplied) {
                                                                      setState(
                                                                          () {
                                                                        isCouponApplied =
                                                                            false;
                                                                        discount =
                                                                            0;
                                                                        discountAmount =
                                                                            "";
                                                                        couponCode =
                                                                            "";
                                                                      });
                                                                      CommonMethods
                                                                          .showShortToast(
                                                                              "Coupon has been removed please apply coupon again");
                                                                    }
                                                                  } else {
                                                                    if (bloc.getCartValue() <
                                                                            minCouponValue ||
                                                                        isCouponApplied) {
                                                                      setState(
                                                                          () {
                                                                        isCouponApplied =
                                                                            false;
                                                                        discount =
                                                                            0;
                                                                        discountAmount =
                                                                            "";
                                                                        couponCode =
                                                                            "";
                                                                      });

                                                                      CommonMethods
                                                                          .showShortToast(
                                                                              "Coupon has been removed please apply coupon again");
                                                                    }
                                                                    setState(
                                                                        () {
                                                                      bloc.removeFromList(
                                                                          orderModelList[
                                                                              index]);
                                                                      if (orderModelList
                                                                              .length ==
                                                                          0) {
                                                                        setState(
                                                                            () {
                                                                          isEmpty =
                                                                              true;
                                                                        });
                                                                      }
                                                                    });
                                                                    print(
                                                                        "SIZEE ${bloc.getRemoveValue()}  ${bloc.getCartValue()}");
                                                                  }
                                                                })
                                                            : Container(),
                                                        Text(
                                                          "${orderModelList[index].count}",
                                                          style: TextStyle(
                                                              color:
                                                                  button_color,
                                                              fontSize: 13),
                                                        ),
                                                        IconButton(
                                                            icon: Icon(
                                                              Icons.add,
                                                              color:
                                                                  button_color,
                                                              size: 15,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                orderModelList[
                                                                        index]
                                                                    .count++;
                                                                // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                                                              });
                                                              if (isCouponApplied) {
                                                                setState(() {
                                                                  isCouponApplied =
                                                                      false;
                                                                  discount = 0;
                                                                  discountAmount =
                                                                      "";
                                                                  couponCode =
                                                                      "";
                                                                });
                                                                CommonMethods
                                                                    .showShortToast(
                                                                        "Coupon has been removed please apply coupon again");
                                                              }
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Text("Rs ${price}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                notification_title_color)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            //SizedBox(height: 10,),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: specialOfferCartList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30),
                                    child: Container(
                                      width: getWidth(context),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                  "${specialOfferCartList[index].name}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          notification_title_color)),
                                              width: getWidth(context) / 2 - 70,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 100,
                                              color: Colors.transparent,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0),
                                              child: Text("Rs ${0}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          notification_title_color)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, right: 30.0),
                              child: Column(
                                children: <Widget>[
                                  CommonMethods.horizontalLine(context),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  billUI("Item Total",
                                      "Rs ${bloc.getCartValue()}"),
                                  billUI("Discount", "Rs ${discount}"),
                                  /* billUI("Taxes","Rs ${bloc.getTax()}"),*/
                                  billUI("Delivery charge", "Rs 0"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CommonMethods.horizontalLine(context),
                                  billUI("Net Payable",
                                      "Rs ${bloc.getCartValue() + bloc.getTax() - discount}"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          "Note: Menu price is inclusive of tax")),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            CommonMethods().thickHorizontalLine(context),
                            SizedBox(
                              height: 10,
                            ),
                            /*Padding(
                    padding: const EdgeInsets.only(left:30.0),
                    child: Container(
                        width: getWidth(context)/2-26,
                        height: 38,
                        decoration: BoxDecoration(
                            border: Border.all(color: input_border_color,width: 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(3.3))
                        ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0,0,5,0),
                        child: Row(
                          children: <Widget>[
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                                value: dropdownValue,
                                elevation: 16,
                                style: TextStyle(
                                    color:  icon_color
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    payment_mode = dropdownValue =="Cash on delivery"?"0":"1";
                                  });
                                },
                                items: <String>['Cash on delivery', 'Online Payment']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: TextStyle(color: Colors.white),),
                                  );
                                })
                                    .toList(),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down,size: 18,color: notification_title_color,)
                          ],
                        ),
                      ),
                    ),
                  ),*/

                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Container(
                                width: getWidth(context) / 2,
                                height: 38,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: input_border_color, width: 0.3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.3))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: notification_title_color,
                                      ),
                                      value: dropdownValueReedem,
                                      // hint: Text("Select for offers"),
                                      elevation: 16,
                                      style: TextStyle(color: icon_color),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValueReedem = newValue;
                                        });

                                        double cartValue = bloc.getCartValue();
                                        double minimumRedeemValue = 200.0;

                                        if (newValue == "Redeem CC Points") {
                                          if (cartValue > minimumRedeemValue) {
                                            if (isCouponApplied ||
                                                isSpecialOfferApplied) {
                                              showWarningDialogOffer("cc");
                                            }
                                          } else {
                                            setState(() {
                                              dropdownValueReedem =
                                                  "Apply coupon code";
                                            });
                                            Fluttertoast.showToast(
                                                msg: "Item Total should "
                                                    "be more than 200 Rs to Redeem CC Points",
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                          }
                                        }

                                        if (newValue == "Apply coupon code") {
                                          if (isRedeemCalled ||
                                              isSpecialOfferApplied) {
                                            showWarningDialogOffer("a");
                                          }
                                        }

                                        if (newValue == "Special Offers") {
                                          if (isRedeemCalled ||
                                              isCouponApplied) {
                                            showWarningDialogOffer("s");
                                          }
                                        }
                                      },
                                      items: <String>[
                                        'Redeem CC Points',
                                        'Apply coupon code',
                                        'Special Offers'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: notification_title_color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            dropdownValueReedem == "Redeem CC Points"
                                ? redeemUI()
                                : dropdownValueReedem == "Apply coupon code"
                                    ? couponUI()
                                    : dropdownValueReedem == "Special Offers"
                                        ? specialOffersUI()
                                        : Container(
                                            height: 20,
                                          ),
                            pickup_delivery == "1" ? deliveryUI() : pickupUI(),
                            CommonMethods().thickHorizontalLine(context),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  List<SpecialOffers> specialOfferCartList = new List();
  bool isSpecialOfferApplied = false;

  Widget specialOffersUI() {
    return specialOffersList.length == 0
        ? Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 20),
              child: Text(
                "No offers available. Continue ordering to be eligible for surprise CC offers.",
                style: TextStyle(color: fab_color),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: specialOffersList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          specialOffersList[index].name,
                          maxLines: 2,
                          style: TextStyle(fontSize: 12, color: icon_color),
                        ),
                        specialOffersList[index].isApplied
                            ? FlatButton(
                                onPressed: () {
                                  setState(() {
                                    isSpecialOfferApplied = false;
                                    specialOfferCartList.clear();
                                    specialOffersList[index].isApplied = false;
                                  });
                                },
                                child: Text(
                                  "Added",
                                  style: TextStyle(color: Colors.black),
                                ),
                                disabledColor: Colors.black26,
                                color: Colors.black26,
                              )
                            : FlatButton(
                                onPressed: () {
                                  if (specialOfferCartList.length == 0) {
                                    setState(() {
                                      isSpecialOfferApplied = true;
                                      specialOfferCartList
                                          .add(specialOffersList[index]);
                                      specialOffersList[index].isApplied = true;
                                      print(
                                          "SPECIAL KEY ===>${specialOfferCartList[0].key}");
                                    });
                                  } else {
                                    CommonMethods.showShortToast(
                                        "You can avail only one item for free please remove previous item");
                                  }
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                                disabledColor: fab_color,
                                color: fab_color,
                              )
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  Widget redeemUI() {
    return Container(
      width: getWidth(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Text(
              "You can redeem maximum of 5000 points (worth Rs 500)",
              style: TextStyle(fontSize: 12, color: notification_title_color),
            ),
            SizedBox(
              height: 8,
            ),
            /*Container(
                  width: getWidth(context)-100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: input_border_color,width: 0.3)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("300",style: TextStyle(color: icon_color,fontSize: 12),),
                        Text("redeem",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                )*/
            redeemPoints >= 2000
                ? Container(
                    width: getWidth(context) - 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border:
                            Border.all(color: input_border_color, width: 0.3)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                          Container(
                              width: getWidth(context) / 2,
                              height: 25,
                              decoration: BoxDecoration(),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<PointsDropdown>(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  value: dropdownReedem,
                                  hint: Text("Select redeem points"),
                                  elevation: 16,
                                  style: TextStyle(color: icon_color),
                                  onChanged: (PointsDropdown newValue) {
                                    setState(() {
                                      dropdownReedem = newValue;
                                    });
                                  },
                                  items: loyaltyPointsList
                                      .map<DropdownMenuItem<PointsDropdown>>(
                                          (PointsDropdown pointsDrop) {
                                    return DropdownMenuItem<PointsDropdown>(
                                      value: pointsDrop,
                                      child: Text(
                                        pointsDrop.value,
                                        style: TextStyle(
                                            color: notification_title_color,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )),
                          InkWell(
                              onTap: () {
                                double cartValue = bloc.getCartValue();
                                double minimumRedeemValue = 200.0;

                                print(cartValue > minimumRedeemValue);
                                if (cartValue > minimumRedeemValue) {
                                  if (_isInternetAvailable) {
                                    if (isRedeemValid()) {
                                      isRedeemCalled = true;
                                      callRedeemOTPAPI();
                                    }
                                  } else {
                                    CommonMethods.showLongToast(CHECK_INTERNET);
                                  }
                                } else {
                                  setState(() {
                                    dropdownValueReedem = "Apply coupon code";
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Item Total should "
                                          "be more than 200 Rs to Redeem CC Points",
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Text(
                                "Redeem",
                                style: TextStyle(
                                    color: button_color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    ),
                  )
                : Text(
                    "You don't have enought points to reedem",
                    style: TextStyle(color: fab_color),
                  ),
            SizedBox(
              height: 10,
            ),
            isRedeemCalled
                ? Container(
                    width: getWidth(context) - 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border:
                            Border.all(color: input_border_color, width: 0.3)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                          Container(
                            width: getWidth(context) / 2,
                            height: 25,
                            child: TextField(
                                controller: _pinEditingController,
                                maxLength: 4,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: notification_title_color),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 15),
                                    hintText: "Enter OTP",
                                    hintStyle: TextStyle(fontSize: 12),
                                    //contentPadding: EdgeInsets.only(bottom: 3),
                                    border: InputBorder.none,
                                    counterText: '')),
                          ),
                          InkWell(
                              onTap: () {
                                if (_isInternetAvailable) {
                                  if (isOtpValid()) {
                                    callApplyLoyaltyPoints();
                                  }
                                } else {
                                  CommonMethods.showLongToast(CHECK_INTERNET);
                                }
                              },
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: button_color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget couponUI() {
    return Container(
      width: getWidth(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Container(
              width: getWidth(context) - 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  border: Border.all(color: input_border_color, width: 0.3)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                    Container(
                      width: getWidth(context) / 2,
                      height: 25,
                      child: TextField(
                          //enableInteractiveSelection: false,
                          controller: controllerCoupon,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: notification_title_color),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 15),
                              hintText: "",
                              hintStyle: TextStyle(fontSize: 12),
                              //contentPadding: EdgeInsets.only(bottom: 3),
                              border: InputBorder.none,
                              counterText: '')),
                    ),
                    InkWell(
                        onTap: () {
                          if (_isInternetAvailable) {
                            if (isCouonValid()) {
                              callCouponAPI();
                            }
                          } else {
                            CommonMethods.showLongToast(CHECK_INTERNET);
                          }
                        },
                        child: Text(
                          "Apply",
                          style: TextStyle(
                              color: button_color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 0),
              child: Text(
                discountAmount == "0" ? "" : discountAmount,
                style: TextStyle(color: hint_text_color, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  String discountAmount = "0";
  double discount = 0;

  Widget pickupUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommonMethods().thickHorizontalLine(context),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            "Delivery Instructions",
            style: TextStyle(fontSize: 13),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Container(
            width: getWidth(context),
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: input_border_color, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(3.3))),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerComment,
                  style: TextStyle(
                      fontSize: 12,
                      // color: heading_color,
                      fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                      hintText: "Instructions (optional)",
                      hintStyle: TextStyle(fontSize: 12),
                      //contentPadding: EdgeInsets.only(bottom: 3),
                      border: InputBorder.none,
                      counterText: ''),
                ),
              ),
            ),
          ),
        ),
        CommonMethods().thickHorizontalLine(context),
        Container(
          width: getWidth(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Pickup Outlet Address",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: notification_title_color),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PickupAddressScreen(
                                        from: "checkout",
                                      )));
                        },
                        child: Text(
                          "change",
                          style: TextStyle(
                              color: button_color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${pickupAddress}",
                  style:
                      TextStyle(fontSize: 12, color: notification_title_color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  addToCart(Menu foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(Menu foodItem) {
    bloc.removeFromList(foodItem);
  }

  Widget deliveryAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(83),
      child: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          color: Colors.white,
          height: 85,
          width: getWidth(context),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomScreen())),
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: icon_color,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Checkout",
                      style: TextStyle(
                          color: text_color,
                          fontSize: 15,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 33.0, top: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressBookScreen(
                                        from: "checkout",
                                      )));
                        },
                        child: RichText(
                            text: TextSpan(
                                text:
                                    "This order is for ${addressName.toUpperCase()} delivery (",
                                style:
                                    TextStyle(color: notification_title_color),
                                children: <TextSpan>[
                              TextSpan(
                                  text: "Change",
                                  style: TextStyle(color: button_color),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ")",
                                      style: TextStyle(
                                          color: notification_title_color),
                                    ),
                                  ]),
                            ]))) /*Text("This order is for home delivery (",style: TextStyle(fontSize: 13,color: hint_text_color),),*/
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pickupAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(83),
      child: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          color: Colors.white,
          height: 85,
          width: getWidth(context),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomScreen())),
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: icon_color,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Checkout",
                      style: TextStyle(
                          color: text_color,
                          fontSize: 15,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 33.0, top: 5),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PickupAddressScreen(
                                        from: "checkout",
                                      )));
                        },
                        child: RichText(
                            text: TextSpan(
                                text: "This order is for pickup (",
                                style:
                                    TextStyle(color: notification_title_color),
                                children: <TextSpan>[
                              TextSpan(
                                  text: "Change",
                                  style: TextStyle(color: button_color),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ")",
                                      style: TextStyle(
                                          color: notification_title_color),
                                    ),
                                  ]),
                            ]))) /*Text("This order is for home delivery (",style: TextStyle(fontSize: 13,color: hint_text_color),),*/
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String addressName = "", deliveryAddress = "", pickupAddress = "";
  List<String> _dropdownThree = ["200", "300", "500"];
  List<String> _dropdownTwo = ["200", "300"];
  List<String> _dropdownOne = ["200"];
  int redeemPoints = 0;
  PointsDropdown dropdownReedem;

  Widget deliveryUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommonMethods().thickHorizontalLine(context),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            "Delivery Instructions",
            style: TextStyle(fontSize: 13),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Container(
            width: getWidth(context),
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: input_border_color, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(3.3))),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerComment,
                  style: TextStyle(
                      fontSize: 12,
                      // color: heading_color,
                      fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                      hintText: "Instructions (optional)",
                      hintStyle: TextStyle(fontSize: 12),
                      //contentPadding: EdgeInsets.only(bottom: 3),
                      border: InputBorder.none,
                      counterText: ''),
                ),
              ),
            ),
          ),
        ),
        CommonMethods().thickHorizontalLine(context),
        Container(
          width: getWidth(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Delivered to ${addressName.toUpperCase()}",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: notification_title_color),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressBookScreen(
                                        from: "checkout",
                                      )));
                        },
                        child: Text(
                          "change",
                          style: TextStyle(
                              color: button_color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${deliveryAddress}",
                  style:
                      TextStyle(fontSize: 12, color: notification_title_color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget billUI(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //child: Text("Name of dish"),
            width: getWidth(context) / 2 - 50,
          ),
          Container(
              //color: button_color,
              width: 90,
              child: Text(
                title,
                style: TextStyle(fontSize: 12, color: notification_title_color),
              )),
          Container(
            //color: Colors.blue,
            width: 50,
            child: Text(price,
                style:
                    TextStyle(fontSize: 12, color: notification_title_color)),
          )
        ],
      ),
    );
  }

  String dropdownValue = 'Cash on delivery';
  String dropdownValueReedem = 'Redeem CC Points';

  //String dropdownValueReedem;
  Widget bottomUI() {
    return Container(
      height: 100,
      width: getWidth(context),
      color: button_color,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Select payment option",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: getWidth(context) / 2,
                  height: 38,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(3.3))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: button_color,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          value: dropdownValue,
                          elevation: 16,
                          style: TextStyle(color: icon_color),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              payment_mode = dropdownValue == "Cash on delivery"
                                  ? "2"
                                  : "1";
                            });
                          },
                          items: <String>['Cash on delivery', 'Online Payment']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
                onTap: () {
                  callapi();
                },
                child: Text(
                  "Place Order",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ),
    );
  }

  printOrder() {
    var items = [];
    print("LEN ${orderModelList.length}");
    for (int i = 0; i < orderModelList.length; i++) {
      var resBody = {};
      if (orderModelList[i].count > 1) {
        print("COUNT ${orderModelList[i].count}");
        for (int j = 0; j < orderModelList[i].count; j++) {
          print("vv${orderModelList[i].name}");
          resBody["hash"] = orderModelList[i].hash;
          resBody["name"] = orderModelList[i].name;
          items.add(resBody);
        }
      } else if (orderModelList[i].count == 1) {
        print("EEE ${orderModelList[i].name}");
        resBody["hash"] = orderModelList[i].hash;
        resBody["name"] = orderModelList[i].name;
        items.add(resBody);
      }
    }
    String orderItems = json.encode(items);
    print("SSS ${json.decode(orderItems)}");

    var specialItems = [];
    var resBodyS = {};
    resBodyS["price"] = specialOfferCartList[0].price;
    resBodyS["name"] = specialOfferCartList[0].name;
    resBodyS["pos_item_id"] = specialOfferCartList[0].id;
    specialItems.add(resBodyS);
    print("DATA SPECIAL===>${json.encode(specialItems)}");
  }

  AddOrderBloc mAddOrderBloc;
  AddOrderResponse mAddOrderResponse;
  String payment_mode = "2";

  callPlaceOrderAPI() async {
    var items = [];
    for (int i = 0; i < orderModelList.length; i++) {
      var resBody = {};
      if (orderModelList[i].count > 1) {
        print("COUNT ${orderModelList[i].count}");
        for (int j = 0; j < orderModelList[i].count; j++) {
          print("vv${orderModelList[i].name}");
          resBody["hash"] = orderModelList[i].hash;
          resBody["name"] = orderModelList[i].name;
          items.add(resBody);
        }
      } else if (orderModelList[i].count == 1) {
        print("EEE ${orderModelList[i].name}");
        resBody["hash"] = orderModelList[i].hash;
        resBody["name"] = orderModelList[i].name;
        items.add(resBody);
      }
    }

    /*"name": "Free Mongolian Chicken",
    "price": 0,
    "pos_item_id": "5c404fcca92ffade252c31b3"*/

    var specialItems = [];
    if (isSpecialOfferApplied) {
      var resBodyS = {};
      resBodyS["price"] = specialOfferCartList[0].price;
      resBodyS["name"] = specialOfferCartList[0].name;
      resBodyS["pos_item_id"] = specialOfferCartList[0].id;
      specialItems.add(resBodyS);
      print("DATA SPECIAL===>${json.encode(specialItems)}");
    }
    String specialItemsS = json.encode(specialItems);
    String orderItems = json.encode(items);
    print("SSS ${json.decode(orderItems)}");

    SharedPreferences preferences = await SharedPreferences.getInstance();

    final body = jsonEncode({
      "del_area": pickup_delivery == "1"
          ? preferences.getString(DELIVERY_ADDRESS_HASH)
          : preferences.getString(PICKUP_ADDRESS_HASH),
      "deliver_pickup": preferences.getString(DELIVERY_PICKUP),
      "coupon_code": couponCode,
      "payment_mode": payment_mode,
      "loyalty_discount": loyalty_discount,
      "is_mobile": "0",
      "reward_id_selected": isRedeemCalled
          ? reward_id_selected
          : isSpecialOfferApplied ? specialOfferCartList[0].key : "",
      "notes": "${controllerComment.text}",
      "net_payable": "${bloc.getCartValue() + bloc.getTax() - discount}",
      "items": json.decode(orderItems),
      "is_special_offer": isSpecialOfferApplied ? "1" : "0",
      "special_offer_items": json.decode(specialItemsS)
    });
    print('COD payment body');
    print(body);

    String data = body;
    print("REQUETS ${data.replaceAll("\\", "").replaceAll('"', "")}");
    mAddOrderBloc = AddOrderBloc(data, "add_order");
    mAddOrderBloc.dataStream.listen((onData) {
      mAddOrderResponse = onData.data;
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context, onData.message);
      } else if (onData.status == Status.COMPLETED) {
        CommonMethods.dismissDialog(context);
        if (mAddOrderResponse.status == 0) {
          CommonMethods.showShortToast(mAddOrderResponse.msg);
        } else {
          bloc.clearCart();
          print("MON ${mAddOrderResponse.rest_bobile}");

          if (reward_id_selected.isNotEmpty && reward_id_selected != null) {
            CommonMethods()
                .redeemsLoyaltyPoints(reward_id_selected: reward_id_selected)
                .whenComplete(() {
              navigationPage(
                  mAddOrderResponse.ordercode, mAddOrderResponse.rest_bobile);
            });
          } else {
            navigationPage(
                mAddOrderResponse.ordercode, mAddOrderResponse.rest_bobile);
            print('reward_id_selected is empty/null');
          }
        }
      } else if (onData.status == Status.ERROR) {
        CommonMethods.dismissDialog(context);

        String msg =
            jsonDecode(onData.message.replaceAll("Invalid Request:", ""))
                .toString()
                .split(":")[1]
                .split(",")[0];
        //CommonMethods.showShortToast(msg);
        showWarningDialog(msg);
      }
    });
  }

  callSuccessOrderAPI(String orderCode, String status, String payment_id,
      String reward_id_selected) async {
    setState(() {
      isSuccessApiCalled = true;
    });

    final body = jsonEncode(
        {"ordercode": orderCode, "status": status, "payment_id": payment_id});

    print('CALLING REDEEM API..??');

    String data = body;
    mAddOrderBloc = AddOrderBloc(data, "payment_resp_api");
    mAddOrderBloc.dataStream.listen((onData) {
      mAddOrderResponse = onData.data;
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context, onData.message);
      } else if (onData.status == Status.COMPLETED) {
        CommonMethods.dismissDialog(context);
        if (mAddOrderResponse.status == 0) {
          CommonMethods.showShortToast(mAddOrderResponse.msg);
        } else {
          setState(() {
            isWebviewopen = false;
          });
          bloc.clearCart();
          print("MON ${mAddOrderResponse.rest_bobile}");

          navigationPage(
              mAddOrderResponse.ordercode, mAddOrderResponse.rest_bobile);
        }
      } else if (onData.status == Status.ERROR) {
        CommonMethods.dismissDialog(context);
        String msg =
            jsonDecode(onData.message.replaceAll("Invalid Request:", ""))
                .toString()
                .split(":")[1]
                .split(",")[0];
        //CommonMethods.showShortToast(msg);
        showWarningDialog(msg);
      }
    });
  }

  showWarningDialogOffer(String from) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 20),
              title: Text(
                "Warning",
                style: TextStyle(color: fab_color),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    "You already have applied an offer applying this offer may remove previously applied method"),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //bloc.clearCart();
                      if (from == "cc") {
                        setState(() {
                          discount = 0.0;
                          discountAmount = "";
                          couponCode = "";
                          isSpecialOfferApplied = false;
                          specialOfferCartList.clear();
                          specialOffersList[0].isApplied = false;
                          isCouponApplied = false;
                        });
                      }

                      if (from == "s") {
                        setState(() {
                          discount = 0.0;
                          discountAmount = "";
                          couponCode = "";
                          isCouponApplied = false;
                          isRedeemCalled = false;
                        });
                      }

                      if (from == "a") {
                        setState(() {
                          isSpecialOfferApplied = false;
                          isRedeemCalled = false;
                          specialOfferCartList.clear();
                          specialOffersList[0].isApplied = false;
                        });
                      }
                    },
                    child: Text(
                      "Ok",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
        });
  }

  showWarningDialog(String from) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 0, right: 20, left: 20),
              title: Text(
                "Warning",
                style: TextStyle(color: fab_color),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(from),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Ok",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
        });
  }

  navigationPage(String orderCode, String mobile) {
    //Navigator.of(context).pushReplacementNamed('/BottomScreen');
    //Navigator.of(context).pushReplacementNamed('/ThanksScreen');
    print("MONNN $mobile");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ThanksScreen(
                  orderCode: orderCode,
                  rest_mobile: mobile,
                )));
  }

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  Future createRequest() async {
    Map<String, String> body = {
      "amount": "10", //amount to be paid
      "purpose": "Advertising",
      "buyer_name": "Pooja",
      "email": "poojajadhav130@gmail.com",
      "phone": "8208282138",
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "http://www.example.com/redirect/"
      //Where to redirect after a successful payment.
      //"webhook": "http://www.example.com/webhook/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.encodeFull("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "dfe6f3c4b461cecd7370e4d71212b450",
          "X-Auth-Token": "tc38184743fe1b1978708960ed15ec6de"
        },
        body: body);
    print("DDD${json.decode(resp.body)['success']}");
    print("ssssDDD${resp.body.toString()}");
    var data = json.decode(resp.body);
    var rest = data["payment_request"];

    // PaymentRequest pay =  rest.map<PaymentRequest>((json) => PaymentRequest.fromJson(json));
    print("OOO${rest['longurl']}");
    //print("ssssDDD${json.decode(resp.body)["payment_request"['longurl']]}");
    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      String longURL = rest['longurl'] + "?embed=form";
      String selectedUrl = longURL;
      flutterWebviewPlugin.close();
      print("$selectedUrl");
//Let's open the url in webview.
      flutterWebviewPlugin.launch(selectedUrl, userAgent: kAndroidUserAgent);
    } else {
      CommonMethods.showLongToast(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }

  _checkPaymentStatus({String id, @required String reward_id_selected}) async {
    var response = await http.get(

        // Uri.encodeFull("${ApiProvider.instaMojoLiveUrl}$id/"),
        Uri.encodeFull("${ApiProvider.instaMojoTestUrl}$id/"),

        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          /*protected $api_key = '9d8a8ce6ac9f6f42792a7e403a915de6';
    protected $auth_token ='4886bf4f24632581c2821a7e7094fe90';*/
          //original key
          // "X-Api-Key": "9d8a8ce6ac9f6f42792a7e403a915de6",
          // "X-Auth-Token": "4886bf4f24632581c2821a7e7094fe90"
          // test key
          "X-Api-Key": ApiProvider.TEST_X_API_KEY,
          "X-Auth-Token": ApiProvider.TEST_X_AUTH_TOKEN
        });
    var realResponse = json.decode(response.body);
    print("SUCC $realResponse");
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        //payment is successful.

        if (reward_id_selected.isNotEmpty && reward_id_selected != null) {
          CommonMethods().redeemsLoyaltyPoints(reward_id_selected: reward_id_selected)
              .whenComplete(() {
            flutterWebviewPlugin.close();
            setState(() {
              isWebviewopen = false;
            });
          });
        }else{
          flutterWebviewPlugin.close();
          setState(() {
            isWebviewopen = false;
          });
        }

        if (!isSuccessApiCalled) {
          String status = realResponse["payment"]['status'];
          String payment_id = realResponse["payment"]['payment_id'];
          callSuccessOrderAPI(
              ordercode, status, payment_id, reward_id_selected);
        }
      } else {
        flutterWebviewPlugin.close();
        setState(() {
          isWebviewopen = false;
          isPaymentFail = true;
        });
        //Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentFailScreen(),));
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }

  Widget paymentFail() {
    return Container(
      color: switch_bg,
      width: getWidth(context),
      height: getHeight(context),
      child: Stack(
        children: <Widget>[
          Container(
            color: button_color,
            width: getWidth(context),
            height: getHeight(context) / 2 - 30,
            alignment: Alignment.center,
          ),
          Positioned(
              top: getHeight(context) / 2 - 205,
              //left: getWidth(context)/2,
              child: Container(
                width: getWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "OOPS!",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Your payment didn’t go through!",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      "assets/images/thanks_img.png",
                      width: 119,
                      height: 138,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Call Us On",
                      style: TextStyle(color: hint_text_color, fontSize: 12),
                    ),
                    Text(
                      "+91-8308800820",
                      style: TextStyle(
                          color: hint_text_color,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () => Navigator.pop(context),
                      disabledColor: button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.3))),
                      child: InkWell(
                          onTap: () {
                            flutterWebviewPlugin.launch(
                              mOnlinePaymentResponse.paymentUrl,
                              withZoom: true,
                              rect: new Rect.fromLTWH(
                                0.0,
                                0.0,
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height,
                              ),
                            );
                            setState(() {
                              isPaymentFail = false;
                            });
                          },
                          child: Text(
                            "Try Again",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      color: button_color,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  OnlinePaymentBloc mOnlinePaymentBloc;
  OnlinePaymentResponse mOnlinePaymentResponse;

  String ordercode;

  callOnlinePaymentAPI() async {
    print("Online");

    var items = [];
    for (int i = 0; i < orderModelList.length; i++) {
      var resBody = {};
      if (orderModelList[i].count > 1) {
        print("COUNT ${orderModelList[i].count}");
        for (int j = 0; j < orderModelList[i].count; j++) {
          print("vv${orderModelList[i].name}");
          resBody["hash"] = orderModelList[i].hash;
          resBody["name"] = orderModelList[i].name;
          items.add(resBody);
        }
      } else if (orderModelList[i].count == 1) {
        print("EEE ${orderModelList[i].name}");
        resBody["hash"] = orderModelList[i].hash;
        resBody["name"] = orderModelList[i].name;
        items.add(resBody);
      }
    }
    String orderItems = json.encode(items);
    print("ONLINE $orderItems");

    var specialItems = [];
    if (isSpecialOfferApplied) {
      var resBodyS = {};
      resBodyS["price"] = specialOfferCartList[0].price;
      resBodyS["name"] = specialOfferCartList[0].name;
      resBodyS["pos_item_id"] = specialOfferCartList[0].id;
      specialItems.add(resBodyS);
      print("DATA SPECIAL===>${json.encode(specialItems)}");
    }
    String specialItemsS = json.encode(specialItems);

    SharedPreferences preferences = await SharedPreferences.getInstance();

    final body = jsonEncode({
      "del_area": pickup_delivery == "1"
          ? preferences.getString(DELIVERY_ADDRESS_HASH)
          : preferences.getString(PICKUP_ADDRESS_HASH),
      "deliver_pickup": preferences.getString(DELIVERY_PICKUP),
      "coupon_code": couponCode,
      "payment_mode": payment_mode,
      "loyalty_discount": loyalty_discount,
      "reward_id_selected": reward_id_selected,
      "notes": "${controllerComment.text}",
      "is_mobile": "0",
      "net_payable": "${bloc.getCartValue() + bloc.getTax() - discount}",
      "items": json.decode(orderItems),
      "is_special_offer": isSpecialOfferApplied ? "1" : "0",
      "special_offer_items": json.decode(specialItemsS)
    });

    print('Online payment body');
    print(body);

    mOnlinePaymentBloc = OnlinePaymentBloc(body);
    mOnlinePaymentBloc.dataStream.listen((onData) {
      mOnlinePaymentResponse = onData.data;
      //print(onData.status);
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context, onData.message);
      } else if (onData.status == Status.COMPLETED) {
        CommonMethods.dismissDialog(context);

        flutterWebviewPlugin.close();
        print("paymentUrl - ${mOnlinePaymentResponse.paymentUrl}");

        if (mOnlinePaymentResponse.paymentUrl != null) {
          //Let's open the url in webview.
          flutterWebviewPlugin.launch(
            mOnlinePaymentResponse.paymentUrl,
            rect: new Rect.fromLTWH(
              0.0,
              0.0,
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            )
            /*"https://test.instamojo.com/@dipak_4d8a6/bf25a6b0e91146479d71b5b002d1ab5d"*/,
            /*userAgent: kAndroidUserAgent*/
          );
          setState(() {
            ordercode = mOnlinePaymentResponse.ordercode;
            isWebviewopen = true;
          });
        } else {
          CommonMethods.showShortToast(
              "Problem in online payment please select COD or try after some time");
        }

        /*  CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mOnlinePaymentResponse.msg);
        navigationPage();*/
      } else if (onData.status == Status.ERROR) {
        CommonMethods.dismissDialog(context);
        String msg =
            jsonDecode(onData.message.replaceAll("Invalid Request:", ""))
                .toString()
                .split(":")[1]
                .split(",")[0];
        //CommonMethods.showShortToast(msg);
        showWarningDialog(msg);
        // CommonMethods.showShortToast(onData.message);

      }
    });
  }

  getOrderType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pickup_delivery = prefs.getString(DELIVERY_PICKUP);
      addressName = prefs.getString(DELIVERY_ADDRESS_NAME);
      deliveryAddress = prefs.getString(DELIVERY_ADDRESS);
      pickupAddress = prefs.getString(PICKUP_ADDRESS);
    });
  }

  bool isCouonValid() {
    if (controllerCoupon.text.length == 0) {
      CommonMethods.showLongToast("Enter coupon");
      return false;
    }
    return true;
  }

  int minCouponValue = 0;
  bool isCouponApplied = false;
  ApplyCouponBloc mApplyCouponBloc;
  ApplyCouponReponse mApplyCouponReponse;
  String couponCode;

  callCouponAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "del_area": pickup_delivery == "1"
          ? preferences.getString(DELIVERY_ADDRESS_HASH)
          : preferences.getString(PICKUP_ADDRESS_HASH),
      "coupon_code": controllerCoupon.text,
      "payment_mode": payment_mode,
      "subtotal": bloc.getCartValue(),
    });

    mApplyCouponBloc = ApplyCouponBloc(body);
    mApplyCouponBloc.dataStream.listen((onData) {
      mApplyCouponReponse = onData.data;
      //print(onData.status);
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context, onData.message);
      } else if (onData.status == Status.COMPLETED) {
        if (mApplyCouponReponse.error == "1") {
          setState(() {
            couponCode = controllerCoupon.text;
            FocusScope.of(context).unfocus();
            controllerCoupon.clear();
            isCouponApplied = false;
            couponCode = "";
            discount = 0;
            discountAmount = "Rs. 0 discount applied";
          });
        } else {
          setState(() {
            isCouponApplied = true;
            couponCode = controllerCoupon.text;
            FocusScope.of(context).unfocus();
            controllerCoupon.clear();
            minCouponValue = int.parse(mApplyCouponReponse.min_cart_val);
            discount = mApplyCouponReponse.discount.toDouble();
            discountAmount =
                "Rs. ${mApplyCouponReponse.discount} discount applied";
          });
        }

        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mApplyCouponReponse.msg);
      } else if (onData.status == Status.ERROR) {
        CommonMethods.dismissDialog(context);

        CommonMethods.showShortToast(onData.message);
      }
    });
  }

  Future<bool> goBack() {
    print("BACK");
    //Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomScreen()));
  }

  Future<bool> exitPayDialog() {
    print('EXIT');
    flutterWebviewPlugin.hide();
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 25),
                        Text(
                          "Are you sure you want to quit the transaction?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: notification_title_color),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: getWidth(context),
                      height: 35,
                      decoration: BoxDecoration(
                          color: button_color,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0))),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop(true);
                                flutterWebviewPlugin.close();
                                setState(() {
                                  isWebviewopen = false;
                                });
                                //SystemNavigator.pop();
                              },
                              child: Text(
                                "Yes, exit me ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                          Container(
                              height: 13,
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Colors.white,
                              )),
                          InkWell(
                              onTap: () {
                                flutterWebviewPlugin.close();
                                flutterWebviewPlugin.launch(
                                    mOnlinePaymentResponse.paymentUrl,
                                    rect: new Rect.fromLTWH(
                                      0.0,
                                      0.0,
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height,
                                    ));
                                Navigator.of(context).pop(false);
                                setState(() {
                                  isWebviewopen = true;
                                });
                              },
                              child: Text(
                                "No, I will continue",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  callapi() {
    if (_isInternetAvailable) {
      if (payment_mode == "2") {
        //printOrder();
        callPlaceOrderAPI();
      } else {
        callOnlinePaymentAPI();
      }
    }
  }

  bool isCCpointsApplied = false;
  LoyaltyPointsBloc mLoyaltyPointsBloc;
  LoyaltyPointsResponse mLoyaltyPointsResponse;

  callPointsAPI() {
    mLoyaltyPointsBloc = LoyaltyPointsBloc();
    mLoyaltyPointsBloc.dataStream.listen((onData) {
      mLoyaltyPointsResponse = onData.data;
      //print(onData.status);
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        // CommonMethods.showLoaderDialog(context,onData.message);
      } else if (onData.status == Status.COMPLETED) {
        //CommonMethods.dismissDialog(context);
        if (mLoyaltyPointsResponse.points == null ||
            mLoyaltyPointsResponse.points == 0) {
          setState(() {
            redeemPoints = 0;
          });
        } else {
          setState(() {
            redeemPoints = mLoyaltyPointsResponse.points;
          });
        }
        print("REDD $redeemPoints");
      } else if (onData.status == Status.ERROR) {
        // CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);
      }
    });
  }

  bool isRedeemValid() {
    if (dropdownReedem == null) {
      CommonMethods.showLongToast("Select redeem option");
      return false;
    }
    return true;
  }

  RedeemOTPBloc mRedeemOTPBloc;
  RedeemOTPResponse mRedeemOTPResponse;

  callRedeemOTPAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "number": preferences.getString(PHONE_NUMBER) /*"8554063733"*/,
    });
    mRedeemOTPBloc = RedeemOTPBloc(body);
    mRedeemOTPBloc.dataStream.listen((onData) {
      mRedeemOTPResponse = onData.data;
      //print(onData.status);
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context, onData.message);
      } else if (onData.status == Status.COMPLETED) {
        CommonMethods.dismissDialog(context);
        setState(() {
          isRedeemCalled = true;
        });
      } else if (onData.status == Status.ERROR) {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);
      }
    });
  }

  ApplyLoyaltyBloc mApplyLoyaltyBloc;
  ApplyLoyaltyResponse mApplyLoyaltyResponse;

  callApplyLoyaltyPoints() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "number": /*preferences.getString(PHONE_NUMBER)*/ "8554063733",
      "otp": _pinEditingController.text,
      "reward_id": dropdownReedem.key
    });

    mApplyLoyaltyBloc = ApplyLoyaltyBloc(body);
    mApplyLoyaltyBloc.dataStream.listen((onData) {
      mApplyLoyaltyResponse = onData.data;
      //print(onData.status);
      if (onData.status == Status.LOADING) {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context, onData.message);
      } else if (onData.status == Status.COMPLETED) {
        setState(() {
          //discountAmount ="Rs ${mApplyLoyaltyResponse.discount} discount applied";
        });
        CommonMethods.dismissDialog(context);
        // print('apply loyl discount');
        // print(mApplyLoyaltyResponse.toJson());
        CommonMethods.showShortToast(mApplyLoyaltyResponse.applyDiscount);
        String d = mApplyLoyaltyResponse.applyDiscount.split(" ")[0];
        setState(() {
          reward_id_selected = dropdownReedem.key;
          discount = double.parse(d);
          loyalty_discount = discount.toString();
        });
      } else if (onData.status == Status.ERROR) {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);
      }
    });
  }

  http.Response response;
  List<PointsDropdown> loyaltyPointsList = new List();
  List<SpecialOffers> specialOffersList = new List();

  void callDropdownAPI() async {
    String uri = '${ApiProvider.BASE_URL}user/getloyaltypoint';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': token
    };

    final body = jsonEncode({
      "number": prefs.getString(PHONE_NUMBER),
    });

    print('Parms MOBILE ${prefs.getString(PHONE_NUMBER)}');

    try {
      final response = await http.post(uri, body: body, headers: headers);
      var responseJson = _response(response);
      print("REDD   ${responseJson}");
      var listJson = jsonEncode(responseJson);
      print("Sss $listJson");
      if (responseJson.toString().contains("error")) {
        CommonMethods.showLongToast(responseJson["message"]);
      } else {
        if (responseJson["select_points"].toString() != "[]") {
          Map<String, dynamic> jsonParsed = responseJson["select_points"];

          jsonParsed.keys.forEach((String key) {
            print("bbb $key");
            _dates.add(key);
          });

          for (int i = 0; i < _dates.length; i++) {
            print(jsonParsed[_dates[i]]);

            final PointsDropdown points =
                PointsDropdown(key: _dates[i], value: jsonParsed[_dates[i]]);
            setState(() {
              loyaltyPointsList.add(points);
            });
          }
        }
        if (responseJson["special_offer"].toString() != "[]") {
          //Map<String, dynamic> jsonParsed = responseJson["special_offer"];

          var rest = responseJson["special_offer"] as List;
          print(rest);
          for (int i = 0; i < rest.length; i++) {
            print("SPE ==>${rest[i]["pos_item_id"]}");
            final SpecialOffers points = SpecialOffers(
                name: rest[i]["dish_name"].toString(),
                price: rest[i]["price"].toString(),
                id: rest[i]["pos_item_id"].toString(),
                key: rest[i]["id"].toString(),
                isApplied: false);
            specialOffersList.add(points);
          }
        }
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print("200");
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        print("400");
        // var responseJson = json.decode(response.body.toString());
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  bool isOtpValid() {
    if (_pinEditingController.text.length == 0) {
      CommonMethods.showLongToast("Enter  OTP");
      return false;
    }

    if (_pinEditingController.text.length < 4) {
      CommonMethods.showLongToast("Enter valid OTP");
      return false;
    }
    return true;
  }

  Widget EmptyCart() {
    return Container(
      width: getWidth(context),
      height: getHeight(context) - 164,
      child: Stack(
        children: <Widget>[
          Container(
            color: button_color,
            width: getWidth(context),
            height: getHeight(context) / 2 - 110,
            alignment: Alignment.center,
          ),
          Positioned(
              top: getHeight(context) / 2 - 308,
              //left: getWidth(context)/2,
              child: Container(
                width: getWidth(context),
                height: getHeight(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "OOPS!",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "There is no item in your cart.\nLet's add something.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      "assets/images/thanks_img.png",
                      width: 119,
                      height: 138,
                    ),
                    SizedBox(
                      height: 40,
                    ),

                    //Text("Call Us On",style: TextStyle(color: hint_text_color,fontSize: 12),),
                    //Text("+91-99999 99999",style: TextStyle(color: hint_text_color,fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomScreen()),
                      ),
                      disabledColor: button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.3))),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: button_color,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
