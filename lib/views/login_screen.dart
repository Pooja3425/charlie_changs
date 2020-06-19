import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controllerNumber = TextEditingController();
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
                child: Image.asset("assets/images/reg_img.png",fit: BoxFit.cover,),
              ),
              Padding(
                padding: const EdgeInsets.only(left:30.0,right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40,),
                    Text(GET_STARTED,style: TextStyle(fontSize: 20,fontFamily: "Manrope",fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                    Container(
                      width: getWidth(context),
                      decoration: BoxDecoration(
                          border: Border.all(color: input_border_color,width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(3.3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          textInputAction: TextInputAction.done,
                          controller: controllerNumber,
                          style: TextStyle(
                             // color: heading_color,
                              fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                              hintText: "Enter phone no.",
                              hintStyle: TextStyle(fontSize: 15),
                              //contentPadding: EdgeInsets.only(bottom: 3),
                              border: InputBorder.none,
                              counterText: ''),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OtpScreen() ),
                        );
                      },
                      elevation: 10,
                      backgroundColor: fab_color,
                      child: Image.asset("assets/images/forword_arrow.png",width: 25,),
                      ),
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
