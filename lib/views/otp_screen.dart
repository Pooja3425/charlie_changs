import 'dart:async';
import 'dart:convert';

import 'package:charliechang/blocs/register_bloc.dart';
import 'package:charliechang/blocs/verify_otp_bloc.dart';
import 'package:charliechang/models/register_response_model.dart';
import 'package:charliechang/models/verify_otp_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/complete_profile_screen.dart';
import 'package:charliechang/views/home_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common_methods.dart';
import '../utils/common_methods.dart';
import 'bottom_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  OtpScreen({this.mobile});
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _pinEditingController = TextEditingController();

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var device_token;

  @override
  void initState() {
    // CommonMeathods.showShortToast(widget.otp);

    _firebaseMessaging.getToken().then((token){
      setState(() {
        device_token =token;
      });
    });
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);

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

    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          width: getWidth(context),
         // height: getHeight(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: getWidth(context),
                height: getHeight(context)/2,
                child: Image.asset("assets/images/otp_img.png",fit: BoxFit.cover,),
              ),
              Padding(
                padding: const EdgeInsets.only(left:30.0,right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(ENTER_OTP,style: TextStyle(fontSize: 20,fontFamily: "Manrope",fontWeight: FontWeight.bold),),
                        InkWell(
                            onTap: ()=>Navigator.of(context).pop(),
                            child: Text(CHNAGE_PHONE_NO,style: TextStyle(fontSize: 15,color: fab_color,fontFamily: "Manrope",fontWeight: FontWeight.w500),)),
                      ],
                    ),
                    SizedBox(height: 30,),
                    /*PinInputTextField(
                      pinLength: 6,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      enableInteractiveSelection: true,
                      decoration: BoxLooseDecoration(
                        enteredColor: input_border_color,
                        strokeColor: input_border_color,
                        radius: Radius.circular(3.3),
                        gapSpace: 10,
                        textStyle: TextStyle(fontSize: 15,color: Colors.black),
                        obscureStyle: ObscureStyle(
                          isTextObscure: false,

                        ),
                        //hintText: _kDefaultHint,
                      ),
                      controller: _pinEditingController,
                      textInputAction: TextInputAction.go,
                      enabled: true,
                      onSubmit: (pin) {
                        // debugPrint('submit pin:$pin');

                      },
                      onChanged: (pin) {
                        debugPrint('onChanged execute. pin:$pin');
                      },
                    ),*/
                   // onlySelectedBorderPinPut(),
                    pinCodeUI(),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                            onTap: (){
                              callRegisterAPI();
                            },
                            child: Container(child: Text(RESEND_OTP,style: TextStyle(fontSize: 15,color: fab_color,fontFamily: "Manrope",fontWeight: FontWeight.w500),))),
                        FloatingActionButton(onPressed: (){

                          if(isValid())
                            {
                              callVerifyOtpAPI();
                            }
                        },
                          elevation: 10,
                          backgroundColor: fab_color,
                          child: Image.asset("assets/images/forword_arrow.png",width: 25,),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget pinCodeUI()
  {
    return PinCodeTextField(
      length: 6,
      obsecureText: false,
      animationType: AnimationType.fade,
      textInputType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        borderWidth: 0.3,
        inactiveFillColor: Colors.black12,
        inactiveColor: Colors.white,
        activeColor: button_color,
        activeFillColor: Colors.white,
        selectedFillColor: button_color
      ),
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.white10,
      enableActiveFill: true,
     // errorAnimationController: errorController,
      controller: _pinEditingController,
      onCompleted: (v) {
        print("Completed");
      },
      onChanged: (value) {
        print(value);
        setState(() {
         // currentText = value;
        });
      },
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
  final FocusNode _pinPutFocusNode = FocusNode();
  Widget onlySelectedBorderPinPut() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color.fromRGBO(235, 236, 237, 1),
      borderRadius: BorderRadius.circular(5),
    );

    return PinPut(
      fieldsCount: 6,
      textStyle: TextStyle(fontSize: 25, color: Colors.black),
      eachFieldWidth: 45,
      eachFieldHeight: 45,
      autofocus: true,

      //onSubmit: (String pin) => _showSnackBar(pin),
      focusNode: _pinPutFocusNode,
      controller: _pinEditingController,
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration.copyWith(
          //color: Colors.white,
          border: Border.all(
            width: 2,
            color: button_color,
          )),
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
    );
  }

  RegisterBloc _registerBloc;
  Map<String, dynamic> bodyDataReg;
  RegisterResponse regRes;

  void callRegisterAPI() {
    final body = jsonEncode({"mobile":widget.mobile});
    _registerBloc=RegisterBloc(body);
    _registerBloc.dataStream.listen((onData){
      regRes = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast("OTP resent");
        //navigationPage();
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }

  VerifyOtpBloc _verifyOtpBloc;
  final _controllerOtp = TextEditingController();
  Map<String, dynamic> bodyData;
  Map<String, dynamic> bodyDataResendOTP;
  VerifyOtpResponse verifyOtpRes;

   callVerifyOtpAPI() {
   /* bodyData={
      "mobile":widget.mobile,
      "otp":_pinEditingController.text
    };*/
    final body = jsonEncode({"mobile":widget.mobile,
      "otp":_pinEditingController.text,
      "device_token":device_token});

    _verifyOtpBloc=VerifyOtpBloc(body);
    _verifyOtpBloc.dataStream.listen((onData){
      verifyOtpRes = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
          CommonMethods.dismissDialog(context);

          if(verifyOtpRes.completeProfile =="0")
            {

              CommonMethods.showShortToast(verifyOtpRes.msg);
              CommonMethods.setPreference(context, "token", verifyOtpRes.token);
              CommonMethods.setPreference(context, COUPON_CODE, verifyOtpRes.couponCode);
              CommonMethods.setPreference(context, COMPLETE_PROFILE, verifyOtpRes.completeProfile);
              navigateToCompleteProfile();
            }
          else
            {
              CommonMethods.setPreference(context, "token", verifyOtpRes.token);
              CommonMethods.setPreference(context, COUPON_CODE, verifyOtpRes.couponCode);
              CommonMethods.setPreference(context, COMPLETE_PROFILE, verifyOtpRes.completeProfile);
              CommonMethods.setPreference(context, PHONE_NUMBER, widget.mobile);
              navigateToHome();
            }



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

  void navigateToCompleteProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompleteProfileScreen() ),
    );
  }

   navigateToHome() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     if(prefs.getString(DELIVERY_ADDRESS_NAME)!=null )
     {
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => BottomScreen() ),
         );
       }
     else
       {
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => AddressBookScreen(from: "otp",) ),
         );
       }


  }

  bool isValid() {
    if(_pinEditingController.text.length==0){
      CommonMethods.showShortToast("Please enter OTP");
      return false;
    }

    if(_pinEditingController.text.length<6){
      CommonMethods.showShortToast("Please enter complete OTP");
      return false;
    }
    return true;
  }
}
