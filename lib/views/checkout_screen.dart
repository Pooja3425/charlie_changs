import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/add_order_bloc.dart';
import 'package:charliechang/blocs/apply_coupon_bloc.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/blocs/loyalty_points_bloc.dart';
import 'package:charliechang/blocs/online_payment_bloc.dart';
import 'package:charliechang/blocs/provider.dart';
import 'package:charliechang/blocs/redeem_otp_bloc.dart';
import 'package:charliechang/models/add_order_response_model.dart';
import 'package:charliechang/models/apply_coupon_response.dart';
import 'package:charliechang/models/loyalty_points_response.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/online_payment_response.dart';
import 'package:charliechang/models/order_model.dart';
import 'package:charliechang/models/redeem_otp_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/pay_screen.dart';
import 'package:charliechang/views/pickup_address_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => new CheckoutScreen(),
          '/widget': (_) {
            return SafeArea(
              child: WebviewScaffold(

                url: selectedUrl,
                javascriptChannels: jsChannels,
                mediaPlaybackRequiresUserGesture: false,
                appBar: AppBar(
                  title: const Text('Widget WebView'),
                ),
                withZoom: false,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  height: getHeight(context),
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )
                ),

              ),
            );
          },
        },
      ),
    );
  }
}
class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //int itemTotal=0;
  List<Menu> orderModelList= new List();
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  final controllerCoupon = TextEditingController();
  final controllerRedeem = TextEditingController();

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
  bool isRedeemCalled=false;
  @override
  void initState() {
      getOrderType();
      print("CART COUNT ${bloc.getCartValue()}");
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
      flutterWebviewPlugin.onUrlChanged.listen((String url) {
        if (mounted) {
          if (url.contains(
              'https://charliechangs.in/thankyou')) {
            Uri uri = Uri.parse(url);
//Take the payment_id parameter of the url.
            String paymentRequestId = uri.queryParameters['payment_id'];
//calling this method to check payment status
            _checkPaymentStatus(paymentRequestId);
          }
          else {
            print("ELSE");
          }
        }
      });

      if (dropdownValueReedem == "Redeem CC Points") {
        if (_isInternetAvailable)
          callPointsAPI();
        else
          CommonMethods.showLongToast(CHECK_INTERNET);
      }
    super.initState();
  }
  int total=0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: isWebviewopen ? exitPayDialog:null,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
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
                  padding: const EdgeInsets.only(right:30.0,left: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: ()=> Navigator.of(context).pop(),
                              child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                          SizedBox(width: 10,),
                          Text("Checkout",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:33.0,top: 5),
                        child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddressBookScreen(from: "checkout",)));
                            },
                            child: RichText(text: TextSpan(text:"This order is for ${addressName.toUpperCase()} delivery (",style: TextStyle(color: notification_title_color),children: <TextSpan>[TextSpan(text: "Change",style: TextStyle(color: button_color),children: <TextSpan>[TextSpan(text: ")",style: TextStyle(color: notification_title_color),),]),])))/*Text("This order is for home delivery (",style: TextStyle(fontSize: 13,color: hint_text_color),),*/
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomUI(),
          body: SingleChildScrollView(
            child: Container(
              width: getWidth(context),
              child: Column(
                children: <Widget>[
                  CommonMethods().thickHorizontalLine(context),
                  StreamBuilder(
                    stream: bloc.listStream,
                    builder: (context,snapshot){
                      if(snapshot.hasData)
                        {
                          orderModelList = snapshot.data;
                          return  ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orderModelList.length  ,
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                int price = int.parse(orderModelList[index].price)*orderModelList[index].count;
                                int itemTotal=0;
                                itemTotal = itemTotal+int.parse(orderModelList[index].price)*orderModelList[index].count;
                                total = itemTotal;
                                return Padding(
                                  padding: const EdgeInsets.only(left:30.0,right: 30.0),
                                  child: Container(
                                    width: getWidth(context),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20,bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Text("${orderModelList[index].name}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                                            width: getWidth(context)/2-70,
                                          ),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: button_color,width: 0.5),
                                                borderRadius: BorderRadius.all(Radius.circular(3.3))),
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                                                  if(orderModelList[index].count!=1)
                                                  {
                                                    setState(() {
                                                      orderModelList[index].count--;
                                                    });
                                                  }
                                                }),
                                                Text("${orderModelList[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                                                IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                                                  setState(() {
                                                    orderModelList[index].count++;
                                                    // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                                                  });
                                                })
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: Text("Rs ${price}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      else
                        {
                          return Container();
                        }

                    },
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30.0),
                    child: Column(
                      children: <Widget>[
                        CommonMethods.horizontalLine(context),
                        SizedBox(height: 10,),
                        billUI("Item Total","Rs ${bloc.getCartValue()}"),
                        billUI("Discount","Rs ${discountAmount}"),
                        billUI("Taxes","Rs ${bloc.getTax()}"),
                        billUI("Delivery charge","Rs 0"),
                        SizedBox(height: 20,),
                        CommonMethods.horizontalLine(context),
                        billUI("Net Payable","Rs ${bloc.getCartValue()+bloc.getTax()+30}"),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  CommonMethods().thickHorizontalLine(context),
                  Container(
                    width: getWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30.0,20,30,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              /*Text("Redeem CC Points",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),*/
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                                  value: dropdownValueReedem,
                                  elevation: 16,
                                //  hint: Text("Select reward or coupon"),
                                  style: TextStyle(
                                      color:  icon_color
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValueReedem = newValue;
                                      /*if(dropdownValueReedem =="Redeem CC Points")
                                        {
                                          if(_isInternetAvailable)
                                          callPointsAPI();
                                          else
                                            CommonMethods.showLongToast(CHECK_INTERNET);
                                        }*/
                                    });
                                  },
                                  items: <String>['Redeem CC Points','Apply coupon code']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,style: TextStyle(color: notification_title_color,fontWeight: FontWeight.bold),),
                                    );
                                  })
                                      .toList(),
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down,size: 18,color: notification_title_color,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  dropdownValueReedem =="Redeem CC Points"?deliveryUI():pickupUI(),
                  CommonMethods().thickHorizontalLine(context),

                ],
              ),

            ),
          ),
        ),
      ),
    );
  }

  String discountAmount="";
  Widget pickupUI()
  {
    return Column(
      children: <Widget>[
        Container(
          width: getWidth(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0,0,30,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: 8,),
                Container(

                  width: getWidth(context)-100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: input_border_color,width: 0.3)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                        Container(
                          width:getWidth(context)/2,
                          height: 25,
                          child: TextField(
                            controller: controllerCoupon,
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 15),
                                  hintText: "",
                                  hintStyle: TextStyle(fontSize: 12),
                                  //contentPadding: EdgeInsets.only(bottom: 3),
                                  border: InputBorder.none,
                                  counterText: '')
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              if(_isInternetAvailable)
                                {
                                  if(isCouonValid())
                                    {
                                      callCouponAPI();
                                    }
                                }
                              else
                                {
                                  CommonMethods.showLongToast(CHECK_INTERNET);
                                }
                            },
                            child: Text("Apply",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:8.0,left:20),
                  child: Text(discountAmount,style: TextStyle(color: hint_text_color,fontSize: 12),),
                )
              ],
            ),
          ),
        ),
        CommonMethods().thickHorizontalLine(context),
        Container(
          width: getWidth(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0,20,30,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Pickup Outlet Address",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                    Text("change",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(height: 8,),
                Text("${pickupAddress}",style: TextStyle(fontSize: 12,color: notification_title_color),),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget deliveryAppBar()
  {

  }


  Widget ickupAppBar()
  {
    PreferredSize(
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
            padding: const EdgeInsets.only(right:30.0,left: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: ()=> Navigator.of(context).pop(),
                        child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                    SizedBox(width: 10,),
                    Text("Checkout",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left:33.0,top: 5),
                    child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PickupAddressScreen(from: "checkout",)));
                        },
                        child: RichText(text: TextSpan(text:"This order is for pickup (",style: TextStyle(color: notification_title_color),children: <TextSpan>[TextSpan(text: "Change",style: TextStyle(color: button_color),children: <TextSpan>[TextSpan(text: ")",style: TextStyle(color: notification_title_color),),]),])))/*Text("This order is for home delivery (",style: TextStyle(fontSize: 13,color: hint_text_color),),*/
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  String addressName="",deliveryAddress="",pickupAddress="";
  List<String> _dropdownThree = ["200","300","500"];
  List<String> _dropdownTwo = ["200","300"];
  List<String> _dropdownOne = ["200"];
  int redeemPoints =0;
  String dropdownReedem;
  Widget deliveryUI(){
    return Column(
      children: <Widget>[
        Container(
          width: getWidth(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0,0,30,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text("You can redeem maximum of 500 points (worth Rs 5000)",style: TextStyle(fontSize: 12,color: notification_title_color),),
                SizedBox(height: 8,),
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
               redeemPoints>=2000? Container(
                  width: getWidth(context)-100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: input_border_color,width: 0.3)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                        Container(
                          width:getWidth(context)/2,
                          height: 25,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                              value: dropdownReedem,
                              hint: Text("Select redeem points"),
                              elevation: 16,
                              style: TextStyle(
                                  color:  icon_color
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownReedem = newValue;
                                });
                              },
                              items: redeemPoints>=2000?_dropdownOne.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: notification_title_color,fontWeight: FontWeight.bold),),
                                );
                              })
                                  .toList():redeemPoints>=3000?_dropdownTwo.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: notification_title_color,fontWeight: FontWeight.bold),),
                                );
                              })
                                  .toList():_dropdownThree.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: notification_title_color,fontWeight: FontWeight.bold),),
                                );
                              })
                                  .toList(),
                            ),
                          )
                        ),
                        InkWell(
                            onTap: (){
                              if(_isInternetAvailable)
                              {
                                if(isRedeemValid())
                                {
                                  isRedeemCalled=true;
                                  callRedeemOTPAPI();
                                  //callCouponAPI();
                                }
                              }
                              else
                              {
                                CommonMethods.showLongToast(CHECK_INTERNET);
                              }
                            },
                            child: Text("Redeem",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                  ),
                ):Text("You dont have enought points to reedem"),
                SizedBox(height: 10,),
                isRedeemCalled?Container(

                  width: getWidth(context)-100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: input_border_color,width: 0.3)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                        Container(
                          width:getWidth(context)/2,
                          height: 25,
                          child: TextField(
                              controller: _pinEditingController,
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 15),
                                  hintText: "",
                                  hintStyle: TextStyle(fontSize: 12),
                                  //contentPadding: EdgeInsets.only(bottom: 3),
                                  border: InputBorder.none,
                                  counterText: '')
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              if(_isInternetAvailable)
                              {
                                if(isCouonValid())
                                {
                                  callCouponAPI();
                                }
                              }
                              else
                              {
                                CommonMethods.showLongToast(CHECK_INTERNET);
                              }
                            },
                            child: Text("Apply",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                  ),
                ):Container(),
              ],
            ),
          ),
        ),
        CommonMethods().thickHorizontalLine(context),
        Container(
          width: getWidth(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0,20,30,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Delivered to ${addressName.toUpperCase()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                    InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddressBookScreen(from: "checkout",)));
                        },
                        child: Text("change",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),)),
                  ],
                ),
                SizedBox(height: 8,),
                Text("${deliveryAddress}",style: TextStyle(fontSize: 12,color: notification_title_color),),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget billUI(String title,String price)
  {
    return Padding(
      padding: const EdgeInsets.only(top:15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //child: Text("Name of dish"),
            width: getWidth(context)/2-50,
          ),
          Container(
            //color: button_color,
              width: 90,
              child: Text(title,style: TextStyle(fontSize: 12,color: notification_title_color),)),
          Container(
            //color: Colors.blue,
            width: 50,
            child: Text(price,style: TextStyle(fontSize: 12,color: notification_title_color)),
          )
        ],
      ),
    );
  }

  String dropdownValue = 'Cash on delivery';
  String dropdownValueReedem = 'Redeem CC Points';
  Widget bottomUI() {
    return Container(
      height: 100,
      width: getWidth(context),
      color: button_color,
      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select payment option",style: TextStyle(color: Colors.white,fontSize: 12 ),),
                SizedBox(height: 7,),
                Container(
                  width: getWidth(context)/2,
                  height: 38,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:5.0,right: 5.0),
                    child:  Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: button_color,
                      ),
                      child: DropdownButtonHideUnderline(
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
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
                onTap: ()=>{

                  callapi()
                  /*if(payment_mode =="0")
                   {
                     callPlaceOrderAPI()
                   }
                  else
                    {
                    createRequest()
                     // Navigator.push(context,MaterialPageRoute(builder: (context) => PayScreen() ),)
                    }*/

                },
                child: Text("Place Order",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600 ),)),
          ],
        ),
      ),
    );
  }

  AddOrderBloc mAddOrderBloc;
  AddOrderResponse mAddOrderResponse;
  String payment_mode="0";

  callPlaceOrderAPI() async{
    var resBody = {};
    var items = [];
    for(int i=0;i<orderModelList.length;i++)
      {
        if(orderModelList[i].count>1)
          {
            for(int j=0;j<orderModelList[i].count;j++)
              {
                resBody["hash"]=orderModelList[i].hash;
                resBody["name"]=orderModelList[i].name;
                items.add(resBody);
              }
          }
        else
          {
            resBody["hash"]=orderModelList[i].hash;
            resBody["name"]=orderModelList[i].name;
            items.add(resBody);
          }
      }


    String orderItems = json.encode(items);
    print("SSS ${json.decode(orderItems)}");

    SharedPreferences preferences = await SharedPreferences.getInstance();
        final body = jsonEncode({"del_area":pickup_delivery =="1"?preferences.getString(DELIVERY_ADDRESS_HASH):preferences.getString(PICKUP_ADDRESS_HASH),
          "deliver_pickup":preferences.getString(DELIVERY_PICKUP),
          "coupon_code":"",
          "payment_mode":payment_mode,
          "reward_id_selected":"",
          "notes":"do not proceed test order from development team",
          "items":json.decode(orderItems)});


        String data = body;
    print("REQUETS ${data.replaceAll("\\", "").replaceAll('"', "")}");
    mAddOrderBloc=AddOrderBloc(data);
    mAddOrderBloc.dataStream.listen((onData){
      mAddOrderResponse = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {

        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mAddOrderResponse.msg);
        bloc.clearCart();
        navigationPage();
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);

        CommonMethods.showShortToast(onData.message);

      }
    });
  }

  navigationPage() {
    Navigator.of(context).pushReplacementNamed('/BottomScreen');
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
          "X-Api-Key": "test_8338f3d1e94dd539eecfec357cb",
          "X-Auth-Token": "test_86f3567ae710bfb0eba0dbad138"
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
      String longURL = rest['longurl']+
          "?embed=form";
      String selectedUrl = longURL;
      flutterWebviewPlugin.close();
      print("$selectedUrl");
//Let's open the url in webview.
      flutterWebviewPlugin.launch(selectedUrl,
      userAgent: kAndroidUserAgent);
    }
    else
    {
      CommonMethods.showLongToast(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        Uri.encodeFull("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_8338f3d1e94dd539eecfec357cb",
          "X-Auth-Token": "test_86f3567ae710bfb0eba0dbad138"
        });
    var realResponse = json.decode(response.body);
    print("SUCC $realResponse");
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
//payment is successful.
        flutterWebviewPlugin.close();

        //callPlaceOrderAPI();
      } else {
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }

  OnlinePaymentBloc mOnlinePaymentBloc;
  OnlinePaymentResponse mOnlinePaymentResponse;

  callOnlinePaymentAPI() async
  {
    print("Online");
    var resBody = {};
    var items = [];
    for(int i=0;i<orderModelList.length;i++)
    {
      if(orderModelList[i].count>1)
      {
        for(int j=0;j<orderModelList[i].count;j++)
        {
          resBody["hash"]=orderModelList[i].hash;
          resBody["name"]=orderModelList[i].name;
          items.add(resBody);
        }
      }
      else
      {
        resBody["hash"]=orderModelList[i].hash;
        resBody["name"]=orderModelList[i].name;
        items.add(resBody);
      }
    }


    String orderItems = json.encode(items);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode({"del_area":pickup_delivery =="1"?preferences.getString(DELIVERY_ADDRESS_HASH):preferences.getString(PICKUP_ADDRESS_HASH),
      "deliver_pickup":preferences.getString(DELIVERY_PICKUP),
      "coupon_code":"",
      "payment_mode":payment_mode,
      "reward_id_selected":"",
      "notes":"do not proceed test order from development team",
      "items":json.decode(orderItems)});

    mOnlinePaymentBloc=OnlinePaymentBloc(body);
    mOnlinePaymentBloc.dataStream.listen((onData){
      mOnlinePaymentResponse = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {

        flutterWebviewPlugin.close();
        print("${mOnlinePaymentResponse.paymentUrl}");
//Let's open the url in webview.
        flutterWebviewPlugin.launch(mOnlinePaymentResponse.paymentUrl,
            userAgent: kAndroidUserAgent);
          setState(() {
            isWebviewopen = true;
          });
      /*  CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mOnlinePaymentResponse.msg);
        navigationPage();*/
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);

        CommonMethods.showShortToast(onData.message);

      }
    });
  }


   getOrderType() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       pickup_delivery = prefs.getString(DELIVERY_PICKUP);
       addressName = prefs.getString(DELIVERY_ADDRESS_NAME);
       deliveryAddress = prefs.getString(DELIVERY_ADDRESS);
       pickupAddress = prefs.getString(PICKUP_ADDRESS);
     });

   }

  bool isCouonValid() {
    if(controllerCoupon.text.length==0)
      {
        CommonMethods.showLongToast("Enter coupon");
        return false;
      }
    return true;
  }

  ApplyCouponBloc mApplyCouponBloc;
  ApplyCouponReponse mApplyCouponReponse;
  callCouponAPI() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode(
      {"del_area":preferences.getString(ADDRESS_HASH),
      "coupon_code":controllerCoupon.text,
      "payment_mode":payment_mode,
      "subtotal":total.toString(),
        });

    mApplyCouponBloc=ApplyCouponBloc(body);
    mApplyCouponBloc.dataStream.listen((onData){
      mApplyCouponReponse = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        setState(() {
          discountAmount ="Rs ${mApplyCouponReponse.discount} discount applied";
        });
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mApplyCouponReponse.msg);
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);

        CommonMethods.showShortToast(onData.message);

      }
    });
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
                borderRadius:
                BorderRadius.circular(10.0)), //this right here
            child: Container(
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(height: 25),
                        Text("Are you sure you want to quit the transaction?",textAlign: TextAlign.center,style: TextStyle(color: notification_title_color),),
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
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0))
                      ),
                      child: Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: (){
                                Navigator.of(context).pop(true);
                                flutterWebviewPlugin.close();
                                setState(() {
                                  isWebviewopen =false;
                                });
                                  //SystemNavigator.pop();
                              },
                              child: Text("Yes, exit me ",style: TextStyle(color: Colors.white,fontSize: 12),)),
                          Container(
                              height: 13,
                              child: VerticalDivider(width: 1,thickness: 1,color: Colors.white,)),
                          InkWell(
                              onTap: (){
                                flutterWebviewPlugin.close();
                                flutterWebviewPlugin.launch(mOnlinePaymentResponse.paymentUrl);
                                Navigator.of(context).pop(false);
                                setState(() {
                                  isWebviewopen=true;

                                });
                              },
                              child: Text("No, I will continue",style: TextStyle(color: Colors.white,fontSize: 12),)),
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
    if(_isInternetAvailable)
    {
      if(payment_mode =="0")
      {
        callPlaceOrderAPI();
      }
      else
      {

        callOnlinePaymentAPI();
      }

    }
  }

  LoyaltyPointsBloc mLoyaltyPointsBloc;
  LoyaltyPointsResponse mLoyaltyPointsResponse;
   callPointsAPI() {
     mLoyaltyPointsBloc=LoyaltyPointsBloc();
     mLoyaltyPointsBloc.dataStream.listen((onData){
       mLoyaltyPointsResponse = onData.data;
       //print(onData.status);
       if(onData.status == Status.LOADING)
       {
         // CommonMethods.displayProgressDialog(onData.message,context);
         CommonMethods.showLoaderDialog(context,onData.message);
       }
       else if(onData.status == Status.COMPLETED)
       {
         CommonMethods.dismissDialog(context);
          if(mLoyaltyPointsResponse.points==null || mLoyaltyPointsResponse.points==0)
            {
              setState(() {
                redeemPoints = 2000;
              });
            }
          else
            {
              setState(() {
                redeemPoints = mLoyaltyPointsResponse.points;
              });

            }
          print("REDD $redeemPoints");
       }
       else if(onData.status == Status.ERROR)
       {
         CommonMethods.dismissDialog(context);
         CommonMethods.showShortToast(onData.message);

       }
     });
   }

  bool isRedeemValid() {
     if(dropdownReedem==null)
       {
         CommonMethods.showLongToast("Select redeem option");
         return false;
       }
     return true;
  }

  RedeemOTPBloc mRedeemOTPBloc;
  RedeemOTPResponse mRedeemOTPResponse;

  callRedeemOTPAPI() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final body = jsonEncode(
        {
          "number":preferences.getString(PHONE_NUMBER),
        });
    mRedeemOTPBloc=RedeemOTPBloc(body);
    mRedeemOTPBloc.dataStream.listen((onData){
      mRedeemOTPResponse = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);

      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }
}
