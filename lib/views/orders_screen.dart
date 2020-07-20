import 'dart:async';

import 'package:charliechang/blocs/order_history_bloc.dart';
import 'package:charliechang/models/order_history_respons.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/order_detail_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
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
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    if(_isInternetAvailable)
    {
      callOrdersAPI();
    }
    else
    {
      CommonMethods.showLongToast(CHECK_INTERNET);
    }
    super.initState();
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                height: getHeight(context)-148,
                padding: EdgeInsets.only(top:20),
                child: mOrderList.length>0?ListView.builder(
                  itemCount: mOrderList.length,
                  itemBuilder: (context,index){
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
    print("DeliveryD ${orders.deliveryTime}");
    var outputFormat = DateFormat("dd-MM-yyyy");
    var timeFormat = DateFormat("dd-MM-yyyy hh:mm aa");


    int year = int.parse(orders.deliveryDate.split("-")[0]);
    int mn = int.parse(orders.deliveryDate.split("-")[1]);
    int dt = int.parse(orders.deliveryDate.split("-")[2]);
    int hr = int.parse(orders.deliveryTime.split(":")[0]);
    int min = int.parse(orders.deliveryTime.split(":")[1]);


    var date = outputFormat.format(DateTime(year,mn,dt));
    var time = timeFormat.format(DateTime(year,mn,dt,hr,min));
    String deliveryTime = time.split(" ")[1]+" "+time.split(" ")[2];
    print("DATEE $time ");
    return Container(
      width: getWidth(context),
      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${orders.ordercode}",style: TextStyle(color: notification_title_color,fontSize: 15,fontWeight: FontWeight.bold),),
                Text("Delivered",style: TextStyle(color: delivered_text_color,fontSize: 13),),
              ],
            ),
            SizedBox(height: 20,),
            Text("Name of dish x 1, Name of dish x 2, Name of dish x 1",style: TextStyle(color: hint_text_color,fontSize: 12),),
            Padding(
              padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
              child: Text("Rs ${orders.totalAmount} (check details)",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
              child: Text("$date | $deliveryTime  |  Delivery",style: TextStyle(color: hint_text_color,fontSize: 12),),
            ),
            SizedBox(height: 20,),
            Text("repeat order",style: TextStyle(color: button_color,fontSize: 12,),),
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
}
