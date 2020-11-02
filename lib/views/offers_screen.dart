import 'dart:async';

import 'package:charliechang/blocs/coupon_list_bloc.dart';
import 'package:charliechang/models/coupons_list_response.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;
  bool isLoading = true;
  @override
  void initState() {
    // CommonMeathods.showShortToast(widget.otp);
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    if(mounted)
    {
      print("INIT MOUN");
      if(_isInternetAvailable)
      {
        checkLogin();

      }
      else
      {
        CommonMethods.showLongToast(CHECK_INTERNET);
      }
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



  //BuildContext context;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: switch_bg,
        width: getWidth(context),
        height: getHeight(context),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 74,
              width: getWidth(context),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right:30.0,left: 30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen())),
                        child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                    SizedBox(width: 10,),
                    Text("Offers For You",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),

            Container(
              width: getWidth(context),
              height: getHeight(context)-162,
              padding: EdgeInsets.only(top: 30),
              child: isLoading?Center(child: CircularProgressIndicator(),): mCouponsList.length>0?ListView.builder(
                itemCount: mCouponsList.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30.0),
                    child: Container(
                      width: getWidth(context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.3))
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.3))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: getWidth(context),
                                child: Image.network(IMAGE_BASE_URL+mCouponsList[index].coupanImage,height: 150,fit: BoxFit.cover,)),

                            Padding(
                              padding: const EdgeInsets.only(right:20.0,left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  Text(mCouponsList[index].title,
                                    style: TextStyle(fontSize: 15,color: fab_color,fontFamily: "Manrope",fontWeight: FontWeight.bold),),
                                  Text(mCouponsList[index].info,
                                    style: TextStyle(color: icon_color,fontSize: 13),),
                                  SizedBox(height: 15,),
                                  Row(children: <Widget>[
                                    InkWell(
                                        onTap:(){

                                         },
                                        child: Text("use code",style: TextStyle(color: icon_color,),)),
                                      SizedBox(width: 20,),
                                      InkWell(
                                      onTap: (){
                                        Clipboard.setData(new ClipboardData(text: "${mCouponsList[index].couponCode}"));
                                        CommonMethods.showLongToast("Copied to clipboard");
                                      },
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: fab_color,
                                            borderRadius: BorderRadius.all(Radius.circular(3.3))
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right:15,left:15),
                                            child: Row(
                                              children: <Widget>[
                                                Text("${mCouponsList[index].couponCode}",style: TextStyle(color: Colors.white,fontSize: 12),),
                                                SizedBox(width: 10,),
                                                Image.asset("assets/images/copy.png",height: 20,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ):Center(
                child: Text("No coupon found"),
              ),
            )
          ],
        ),
      ),
    );
  }

  CouponListBloc mCouponListBloc;
  CouponListResponse mCouponListResponse;
  List<Data> mCouponsList = new List();
  callCouponAPI() {
    mCouponListBloc=CouponListBloc();
    mCouponListBloc.dataStream.listen((onData){
      mCouponListResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        /*setState(() {
          isLoading = false;
        });*/
        //CommonMethods.displayProgressDialog(onData.message,context);
       // showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        if(mounted)
          {
            print("MO");
          //  dismissDialog(context);
            setState(() {
              isLoading = false;
              mCouponsList= mCouponListResponse.data;
            });
          }


      }
      else if(onData.status == Status.ERROR)
      {
        //dismissDialog(context);
        if(onData.message.contains("Invalid"))
        {
          setState(() {
            isLoading = false;
          });
          CommonMethods.showShortToast("Try after some time");
        }
      }
    });
  }


  static showLoaderDialog(BuildContext context,String message){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(backgroundColor: button_color,valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
          Container(margin: EdgeInsets.only(left: 7),child:Text(message)),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  static dismissDialog(BuildContext context){
    Navigator.pop(context);

  }

   checkLogin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    if(token!=null)
      {
        callCouponAPI();
      }
   }
}
