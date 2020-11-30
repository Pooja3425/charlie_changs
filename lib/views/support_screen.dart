import 'dart:async';
import 'dart:convert';

import 'package:charliechang/blocs/outlets_bloc.dart';
import 'package:charliechang/blocs/support_bloc.dart';
import 'package:charliechang/models/outlets_model.dart';
import 'package:charliechang/models/support_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/repository/support_repository.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _controllerSupport = TextEditingController();
  var rating = 0.0;

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
        callOutletsService();
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
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(74.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.keyboard_backspace,color: icon_color,),
                SizedBox(width: 10,),
                Text("Support",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
              ],
            )
          ),
        ),*/
        body: Container(
          width: getWidth(context),
          height: getHeight(context),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child:  Container(
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
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                      SizedBox(width: 10,),
                      Text("Support",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),),
              Positioned(
                top:74,
                bottom: 73,
                child: Container(
                  width: getWidth(context),
                  height: getHeight(context)-148,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[

                          Container(height: 10,color: switch_bg,
                            width: getWidth(context),),
                          Container(
                            width: getWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.only(right:30.0,left: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10,),
                                  Text("Share your feedback",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 15,),
                                  Container(
                                    width: getWidth(context),
                                    //height: 38,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: input_border_color,width: 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(3.3))
                                    ),
                                    child: Padding(
                                      padding: CommonMethods.textFieldPadding,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        maxLength: 150,
                                        maxLines: 5,
                                        controller: _controllerSupport,
                                        textCapitalization: TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        /*onSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusNewPass);
                                      },*/
                                        style: TextStyle(
                                            color: text_color,
                                            fontWeight: FontWeight.w400,fontSize: 12.5),
                                        decoration: InputDecoration(
                                            hintText: "Type your message",
                                            hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                            //contentPadding: EdgeInsets.only(bottom: 12),
                                            border: InputBorder.none,
                                            counterText: ''),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20.0,bottom: 20),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: FloatingActionButton(onPressed: (){
                                        if(_isInternetAvailable)
                                          {
                                            if(isValid())
                                            callSupportAPI();
                                          }
                                        else
                                          {
                                            CommonMethods.showLongToast(CHECK_INTERNET);
                                          }
                                        /*Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => OtpScreen() ),
                                      );*/
                                      },
                                        elevation: 10,
                                        backgroundColor: fab_color,
                                        child: Image.asset("assets/images/forword_arrow.png",width: 25,),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(height: 10,color: switch_bg,
                            width: getWidth(context),),
                          Container(
                            width: getWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.only(left:30.0,right: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  Text("Connect with us",style: TextStyle(color: notification_title_color,fontSize: 16,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  CommonMethods.horizontalLine(context),
                                  /*SizedBox(height: 20,),
                                  Text("Caranzalem Outlet",style: TextStyle(color: notification_title_color,fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Model's Millennium Vistas, Shop 1, Caranzalem, Goa - 403002 (Opp. Harley Davidson's Showroom)",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 10,),
                                  Text("+91 - 8308800820  |  info@charliechangs.in",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 20,),
                                  CommonMethods.horizontalLine(context),
                                  SizedBox(height: 20,),
                                  Text("Porvorim Outlet",style: TextStyle(color: notification_title_color,fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("House Number 844, After Gauri Petrol Pump, Porvorim, Goa 403051",style: TextStyle(color: icon_color),),
                                  SizedBox(height: 10,),
                                  Text("+91 - 8308800833  |  info@charliechangs.in",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 10,),*/
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                      itemCount: mOutletsList.length,
                                      itemBuilder: (context,index){
                                    return outletsRow(mOutletsList[index]);
                                  })
                                ],
                              ),
                            ),
                          ),
                          Container(height: 10,color: switch_bg,
                            width: getWidth(context),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                width: getWidth(context),
                height: 73,
                color: button_color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Rate your experience",style: TextStyle(color: Colors.white),),
                    InkWell(
                      onTap: (){
                        StoreRedirect.redirect(
                          androidAppId: "com.brandzgarage.charliechang",
                          iOSAppId: ""
                        );
                      },
                      child: SmoothStarRating(
                        rating: rating,
                        isReadOnly: true,
                        size: 20,
                        borderColor: Colors.white,
                        color: Colors.white,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: true,
                        spacing: 2.0,
                        onRated: (value) {
                          print("rating value -> $value");
                          setState(() {
                            //rating_val=value;
                          });
                          // print("rating value dd -> ${value.truncate()}");
                        },
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget outletsRow(Data data)
  {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Text("${data.outletName}",style: TextStyle(color: notification_title_color,fontSize: 14,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("${data.outletAddress}",style: TextStyle(color: notification_title_color),),
          SizedBox(height: 10,),
          Row(
            children: [
              InkWell(
                onTap: ()=>UrlLauncher.launch("tel://${data.outletMobile}"),
                  child: Text("+91 - ${data.outletMobile}  | ",style: TextStyle(color: notification_title_color),)),
              InkWell(
                  onTap: ()=>UrlLauncher.launch("mailto://${data.outletEmail}"),
                  child: Text( "${data.outletEmail}",style: TextStyle(color: notification_title_color),)),
            ],
          ),
          SizedBox(height: 20,),
          CommonMethods.horizontalLine(context),
        ],
      ),
    );
  }

  double rating_val;
  SupportBloc mSupportBloc;
  SupportResponse mSupportResponse;
   callSupportAPI() {
     final body = jsonEncode({"feedback":_controllerSupport.text,"rating":rating_val.toString()});
     mSupportBloc=SupportBloc(body);
     mSupportBloc.dataStream.listen((onData){
       mSupportResponse = onData.data;
       //print(onData.status);
       if(onData.status == Status.LOADING)
       {
         // CommonMethods.displayProgressDialog(onData.message,context);
         CommonMethods.showLoaderDialog(context,onData.message);
       }
       else if(onData.status == Status.COMPLETED)
       {
         _controllerSupport.clear();
         CommonMethods.dismissDialog(context);
         CommonMethods.showShortToast(mSupportResponse.msg);
         //navigationPage();
       }
       else if(onData.status == Status.ERROR)
       {
         CommonMethods.dismissDialog(context);
         CommonMethods.showShortToast(onData.message);

       }
     });
   }

  bool isValid() {
     if(_controllerSupport.text.length==0)
       {
         CommonMethods.showLongToast("Enter you query");
         return false;
       }
     return true;
  }

  List<Data> mOutletsList= new List();
    OutletsBloc mOutletsBloc;
   OutletsResponse mOutletsResponse;
   callOutletsService() async{

     mOutletsBloc=OutletsBloc();
     mOutletsBloc.dataStream.listen((onData){
       mOutletsResponse = onData.data;
       if(onData.status == Status.LOADING)
       {
         CommonMethods.showLoaderDialog(context, "Loading");
       }
       else if(onData.status == Status.COMPLETED)
       {
         CommonMethods.dismissDialog(context);
         setState(() {
           mOutletsList = mOutletsResponse.data;


         });

       }
       else if(onData.status == Status.ERROR)
       {
          CommonMethods.dismissDialog(context);
         CommonMethods.showShortToast(onData.message);
       }
     });
   }
}
