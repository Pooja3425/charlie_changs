import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/blocs/menu_bloc.dart';
import 'package:charliechang/blocs/order_history_bloc.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/order_history_respons.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:charliechang/views/order_detail_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  String from;
  OrdersScreen({this.from});
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    // CommonMeathods.showShortToast(widget.otp);
    _IsSearching=false;
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    if(_isInternetAvailable)
    {
      callOrdersAPI();
      getMenuAPI();
    }
    else
    {
      CommonMethods.showLongToast(CHECK_INTERNET);
    }

    super.initState();
  }

  bool _IsSearching;
  String _searchText = "";

  _OrdersScreenState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchController.text;
          _buildSearchList();
        });
      }

    });
  }

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

  TextEditingController _searchController = TextEditingController();
  // Copy Main List into New List.
  List<Data> newDataList = new List();


  List<Data> _buildSearchList() {
    print("search va $_IsSearching");
    if (_searchText.isEmpty) {
      return newDataList =
          mOrderList; //_list.map((contact) =>  Uiitem(contact)).toList();
    } else {
      newDataList = mOrderList
          .where((element) =>
          element.orderItems[0].itemName.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();

      print('${newDataList.length}');
      return newDataList; //_searchList.map((contact) =>  Uiitem(contact)).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:widget.from=="bottom"?goToBottom:null,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              flexibleSpace:  Container(
                color: Colors.white,
                //height: 107,
                width: getWidth(context),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right:30.0,left: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: ()=>Navigator.of(context).pop(),
                              child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                          SizedBox(width: 10,),
                          Text("Orders",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 8,),
                      Container(
                        height: 40,
                        width: getWidth(context),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: switch_bg,
                            borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //Icon(Icons.search,color: icon_color,size: 18,),
                              SizedBox(width: 3,),
                              Icon(Icons.search,color: icon_color,size: 18,),
                              SizedBox(width: 3,),
                              Container(
                                width: getWidth(context)-110,
                                child: TextField(
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.only(top: 5),
                                    //prefixIcon: Icon(Icons.search,color: icon_color,size: 18,),
                                      hintText: "Search orders",
                                      hintStyle: TextStyle(fontSize: 12,color: icon_color),
                                      //contentPadding: EdgeInsets.only(bottom: 3),
                                      border: InputBorder.none,
                                      counterText: ''
                                  ),
                                  controller: _searchController,
                                  // onChanged: onItemChanged,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          resizeToAvoidBottomPadding: false,
          body: Container(
            width: getWidth(context),
            child:Column(
              children: <Widget>[

                Container(
                  height: 10,color: switch_bg,
                  width: getWidth(context),),

                Container(
                  width: getWidth(context),
                  height: getHeight(context)-152,
                  padding: EdgeInsets.only(top:20),
                  child:_IsSearching?newDataList.length>0?ListView.builder(
                    itemCount: newDataList.length,
                    itemBuilder: (context,index){
                      print("after search");

                      return  deliveryRowUI(newDataList[index]);
                    },

                  ):Center(
                    child: Text("You haven't placed order yet"),
                  ):mOrderList.length>0?ListView.builder(
                    itemCount: mOrderList.length,
                    itemBuilder: (context,index){
                      print("before search");

                      return  deliveryRowUI(mOrderList[index]);
                    },

                  ):Center(
                    child: Text("You haven't placed order yet"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderRowUI() {

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen()));
      },
      child: Container(
        width: getWidth(context),
        child: Padding(
          padding: const EdgeInsets.only(left:30.0,right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("ABCDE12345",style: TextStyle(color: notification_title_color,fontSize: 15,fontWeight: FontWeight.bold),),
                  Text("In Progress",style: TextStyle(color: progress_text_color,fontSize: 13),),
                ],
              ),
              SizedBox(height: 20,),
              Text("Name of dish x 1, Name of dish x 2, Name of dish x 1",style: TextStyle(color: hint_text_color,fontSize: 12),),
              Padding(
                padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
                child: Text("Rs 1,200  (check details)",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
                child: Text("22-Aug-2020 | 8:00 PM  |  Delivery",style: TextStyle(color: hint_text_color,fontSize: 12),),
              ),
              SizedBox(height: 20,),
              Text("repeat order",style: TextStyle(color: button_color,fontSize: 12,),),
              SizedBox(height: 20,),
              CommonMethods.horizontalLine(context)
            ],
          ),
        ),
      ),
    );
  }


  Widget deliveryRowUI(Data orders) {
    //print("DeliveryD ${orders.deliveryTime}");
    var outputFormat = DateFormat("dd-MM-yyyy");
    var timeFormat = DateFormat("dd-MM-yyyy hh:mm aa");

    String order_date = orders.order_date_time.split(" ")[0];
    String order_time = orders.order_date_time.split(" ")[1];
  //  print("TIME==> $order_time");
    int year = int.parse(order_date.split("-")[0]);
    int mn = int.parse(order_date.split("-")[1]);
    int dt = int.parse(order_date.split("-")[2]);
    int hr = int.parse(order_time.split(":")[0]);
    int min = int.parse(order_time.split(":")[1]);
    var date = outputFormat.format(DateTime(year,mn,dt));
    var time = timeFormat.format(DateTime(year,mn,dt,hr,min));
    String deliveryTime = time.split(" ")[1]+" "+time.split(" ")[2];

    String items="";
    for(int i=0;i<orders.orderItems.length;i++)
    {
      items = items+orders.orderItems[i].itemName +" x "+ orders.orderItems[i].quantity+", ";
    }

    // print("DATEE $time ");
    return Container(
      width: getWidth(context),
      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(orderData: orders,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("${orders.ordercode}",style: TextStyle(color: notification_title_color,fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(orders.status =="0"?"In progress":orders.status=="1"?"Delivered":"Cancelled",style: TextStyle(color: orders.status=="2"?fab_color:delivered_text_color,fontSize: 13),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("${items.substring(0,items.length-1)}",style: TextStyle(color: hint_text_color,fontSize: 12),),
                  Padding(
                    padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
                    child: Text("Rs ${orders.totalAmount} (check details)",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
                    child: Text("$date | $deliveryTime  |  Delivery",style: TextStyle(color: hint_text_color,fontSize: 12),),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            InkWell(
                onTap: (){
                  addItemsTocart(orders);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutScreen(),));
                },
                child: Text("repeat order",style: TextStyle(color: button_color,fontSize: 12,),)),
            SizedBox(height: 20,),
            CommonMethods.horizontalLine(context)
          ],
        ),
      ),
    );
  }

  OrderHistoryBloc  mOrderHistoryBloc;
  OrderHistoryResponse mOrderHistoryResponse;
  List<Data> mOrderList = new List();
  callOrdersAPI() {
    mOrderHistoryBloc=OrderHistoryBloc();
    mOrderHistoryBloc.dataStream.listen((onData){
      mOrderHistoryResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);
        setState(() {
          mOrderList= mOrderHistoryResponse.data;
        });
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        if(onData.message.contains("Invalid"))
        {
          CommonMethods.showShortToast("Invalid OTP");
        }
      }
    });
  }

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  addItemsTocart(Data orders) {
    for(int i=0;i<orders.orderItems.length;i++)
    {
      for(int j=0;j<mMenuList.length;j++)
      {
        if(orders.orderItems[i].itemId == mMenuList[j].id)
        {
          print("QUATITY ${orders.orderItems[i].quantity}");
          for(int k=0;k<=int.parse(orders.orderItems[i].quantity);k++)
          {
            print("ITEM NAME ${mMenuList[j].name}");
            addToCart(mMenuList[j]);
          }
        }
      }
    }
  }

  addToCart(Menu foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(Menu foodItem) {
    bloc.removeFromList(foodItem);
  }

  MenuBloc mMenuBloc;
  MenuResponse mMenuResponse;
  List<Menu> mMenuList = new List();

  /*List<FoodItem> foodList = new List();*/
  getMenuAPI() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String hashKey;
    if(preferences.getString(DELIVERY_PICKUP) =="1")
    {
      setState(() {
        hashKey = preferences.get(DELIVERY_ADDRESS_HASH);
      });
    }
    else
    {
      if(preferences.get(PICKUP_ADDRESS_NAME)!=null)
      {
        setState(() {
          hashKey = preferences.get(PICKUP_ADDRESS_HASH);
        });

      }

    }
    final body = jsonEncode({"hash":hashKey,"category":""});
    mMenuBloc=MenuBloc(body);
    mMenuBloc.dataStream.listen((onData){
      mMenuResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.hideDialog();
        setState(() {
          mMenuList = mMenuResponse.menu;


        });
        //CommonMethods.showShortToast(mDeliveryLocationsResponse.);
      }
      else if(onData.status == Status.ERROR)
      {
        // CommonMethods.hideDialog();
        CommonMethods.showShortToast(onData.message);
      }
    });
  }

  Future<bool> goToBottom() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomScreen(),));
  }
}
