
import 'dart:async';

import 'package:charliechang/blocs/loyalty_points_bloc.dart';
import 'package:charliechang/models/loyalty_points_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

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
  void initState() {
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    if(_isInternetAvailable)
      {
        callPointsAPI();
      }
    else
      {
        CommonMethods.showLongToast(CHECK_INTERNET);
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            flexibleSpace: CommonMethods.appBar(context, "Loyalty Points"),
          ),
        ),
         body: Container(
            width: getWidth(context),
            child: Column(
              children: <Widget>[
                Container(
                  width: getWidth(context),
                  height: 10,
                  color: switch_bg,
                ),
                Container(
                  //width: getWidth(context),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15,),
                      Text("You have",style: TextStyle(color: icon_color),),
                      Text("$redeemPoints points",style: TextStyle(color: button_color,fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          showWarningDialog();
                        },
                        child: Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: input_border_color,width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          child: Center(
                            child: Text("Learn how to redeem",style: TextStyle(color: icon_color,fontSize: 12),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: getWidth(context),
                  height: 10,
                  color: switch_bg,
                ),
                /*Container(
                  width: getWidth(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30,top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Transaction History",style: TextStyle(fontWeight: FontWeight.bold,color: notification_title_color),),
                        SizedBox(height: 20,),
                        CommonMethods.horizontalLine(context),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Date",style: TextStyle(fontSize: 12,color: hint_text_color),),
                              Text("CR/DR",style: TextStyle(fontSize: 12,color: hint_text_color),),
                              Text("Points",style: TextStyle(fontSize: 12,color: hint_text_color),)
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: getWidth(context),
                          height: getHeight(context)-392,

                          child: ListView.builder(
                              itemCount: 11,
                              itemBuilder: (context,index){
                            return Container(
                              height: 50,
                              width: getWidth(context),
                              decoration: BoxDecoration(
                                  color: index%2!=0?null:switch_bg,
                                  borderRadius: BorderRadius.all(Radius.circular(3))),

                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("22-Aug-20",style: TextStyle(fontSize: 12,color: hint_text_color),),
                                    Text("CR",style: TextStyle(fontSize: 12,color: hint_text_color),),
                                    Text("+200",style: TextStyle(fontSize: 12,color: hint_text_color),)
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                  ),
                )*/

              ],
            ),
         ),
      ),
    );
  }
  int redeemPoints=0;
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
            redeemPoints = 0;
          });
        }
        else
        {
          setState(() {
            redeemPoints = mLoyaltyPointsResponse.points;
          });

        }
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }

  showWarningDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return WillPopScope(
            onWillPop: (){},
            child: AlertDialog(
              contentPadding: EdgeInsets.only(top: 0,bottom: 0,right: 20,left: 20),
              title: Text("How to redeem",style: TextStyle(color: fab_color),),
              content: Container(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                            ),
                          ),SizedBox(width: 5,),
                          Flexible(child: Text("Select Redeem CC Points option on checkout page.",style: TextStyle(color: Colors.black),)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                            ),
                          ),SizedBox(width: 5,),
                          Flexible(child: Text("Enter numbef of points you want to redeem.",style: TextStyle(color: Colors.black),)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                          ),SizedBox(width: 5,),
                          Flexible(child: Text('Click "Redeem"',style: TextStyle(color: Colors.black),)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                            ),
                          ),SizedBox(width: 5,),
                          Flexible(child: Text("You can redeem maximum 5000 points.",style: TextStyle(color: Colors.black),)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                          ),SizedBox(width: 5,),
                          Flexible(child: Text("2000 points are worth Rs. 200*",style: TextStyle(color: Colors.black),)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[FlatButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("Ok",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),))
              ],
            ),
          );
        }
    );
  }
}
