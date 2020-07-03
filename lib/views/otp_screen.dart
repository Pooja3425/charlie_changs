import 'dart:convert';

import 'package:charliechang/blocs/register_bloc.dart';
import 'package:charliechang/blocs/verify_otp_bloc.dart';
import 'package:charliechang/models/register_response_model.dart';
import 'package:charliechang/models/verify_otp_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/complete_profile_screen.dart';
import 'package:charliechang/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: getWidth(context),
          height: getHeight(context),
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
                    PinInputTextField(
                      pinLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: BoxLooseDecoration(
                        enteredColor: input_border_color,
                        strokeColor: input_border_color,
                        radius: Radius.circular(3.3),
                        gapSpace: 10,
                        textStyle: TextStyle(fontSize: 15,color: Colors.black),
                        obscureStyle: ObscureStyle(
                          isTextObscure: false,
                          obscureText: '☺️',
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
                    ),
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
        CommonMethods.showShortToast(regRes.msg);
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
    final body = jsonEncode({"mobile":widget.mobile,"otp":_pinEditingController.text});

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

  void navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomScreen() ),
    );
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
