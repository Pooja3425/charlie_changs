import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/complete_profile_screen.dart';
import 'package:charliechang/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpScreen extends StatefulWidget {
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
                        Text(CHNAGE_PHONE_NO,style: TextStyle(fontSize: 15,color: fab_color,fontFamily: "Manrope",fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(height: 30,),
                    PinInputTextField(
                      pinLength: 4,
                      keyboardType: TextInputType.number,
                      decoration: BoxLooseDecoration(
                        enteredColor: input_border_color,
                        strokeColor: input_border_color,
                        radius: Radius.circular(3.3),
                        gapSpace: 30,
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
                        Text(RESEND_OTP,style: TextStyle(fontSize: 15,color: fab_color,fontFamily: "Manrope",fontWeight: FontWeight.w500),),
                        FloatingActionButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CompleteProfileScreen() ),
                          );
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
}
