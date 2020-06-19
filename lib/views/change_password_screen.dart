import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _controllerOldPass = TextEditingController();
  final _controllerNewPass = TextEditingController();
  final _controllerRePass = TextEditingController();
  final focusNewPass = FocusNode();
  final focusRePass = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          width: getWidth(context),
          height: getHeight(context),
          child: Stack(
            children: <Widget>[
              Column(
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
                          Icon(Icons.keyboard_backspace,color: icon_color,),
                          SizedBox(width: 10,),
                          Text("Change Password",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10,color: switch_bg,
                    width: getWidth(context),),
                  Container(
                    width: getWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 40),
                      child: Column(
                        children: <Widget>[

                          Container(
                            width: getWidth(context),
                            height: 38,
                            decoration: BoxDecoration(
                                border: Border.all(color: input_border_color,width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(3.3))
                            ),
                            child: Padding(
                              padding: CommonMethods.textFieldPadding,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                maxLength: 15,
                                controller: _controllerOldPass,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focusNewPass);
                                },
                                style: TextStyle(
                                    color: text_color,
                                    fontWeight: FontWeight.w400,fontSize: 12.5),
                                decoration: InputDecoration(
                                    hintText: "Old password",
                                    hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    border: InputBorder.none,
                                    counterText: ''),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: getWidth(context),
                            height: 38,
                            decoration: BoxDecoration(
                                border: Border.all(color: input_border_color,width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(3.3))
                            ),
                            child: Padding(
                              padding: CommonMethods.textFieldPadding,
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 15,
                                focusNode: focusNewPass,
                                controller: _controllerNewPass,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                /*onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focus);
                                },*/
                                style: TextStyle(
                                    color: text_color,
                                    fontWeight: FontWeight.w400,fontSize: 12.5),
                                decoration: InputDecoration(
                                    hintText: "New password",
                                    hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    border: InputBorder.none,
                                    counterText: ''),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: getWidth(context),
                            height: 38,
                            decoration: BoxDecoration(
                                border: Border.all(color: input_border_color,width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(3.3))
                            ),
                            child: Padding(
                              padding: CommonMethods.textFieldPadding,
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 15,
                                focusNode: focusRePass,
                                controller: _controllerRePass,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focusRePass);
                                },
                                style: TextStyle(
                                    color: text_color,
                                    fontWeight: FontWeight.w400,fontSize: 12.5),
                                decoration: InputDecoration(
                                    hintText: "Reconfirm password",
                                    hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    border: InputBorder.none,
                                    counterText: ''),
                              ),
                            ),
                          ),



                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: 0.0,
                  child: Container(
                    width: getWidth(context),
                    height: 73,
                    color: button_color,
                    child: Center(
                      child: Text("Update Details",style: TextStyle(color: Colors.white),),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
