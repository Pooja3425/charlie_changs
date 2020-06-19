
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _controllerFirstName = TextEditingController();
  final _controllerLastName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerEmail = TextEditingController();
  final focusLastName = FocusNode();
  final focusPhone = FocusNode();
  final focusEmail = FocusNode();
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
                  CommonMethods.appBar(context, "Profile"),
                  Container(height: 10,color: switch_bg,
                    width: getWidth(context),),
                  Container(
                    width: getWidth(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 40),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: getWidth(context)/2-40,
                                height: 38,
                                decoration: BoxDecoration(
                                    border: Border.all(color: input_border_color,width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(3.3))
                                ),
                                child: Padding(
                                  padding:CommonMethods.textFieldPadding,
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    maxLength: 15,
                                    controller: _controllerFirstName,
                                    textCapitalization: TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusLastName);
                                    },
                                    style: TextStyle(
                                        color: text_color,
                                        fontWeight: FontWeight.w400,fontSize: 12.5),
                                    decoration: InputDecoration(
                                        hintText: "First name",
                                        hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                        contentPadding: EdgeInsets.only(bottom: 12),
                                        border: InputBorder.none,
                                        counterText: ''),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width: getWidth(context)/2-40,
                                height: 38,
                                decoration: BoxDecoration(
                                    border: Border.all(color: input_border_color,width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(3.3))
                                ),
                                child: Padding(
                                  padding: CommonMethods.textFieldPadding,
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    focusNode: focusLastName,
                                    maxLength: 15,
                                    textCapitalization: TextCapitalization.words,
                                    controller: _controllerLastName,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusPhone);
                                    },
                                    style: TextStyle(
                                        color: text_color,
                                        fontWeight: FontWeight.w400,fontSize: 12.5),
                                    decoration: InputDecoration(
                                        hintText: "Last name",
                                        hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                        contentPadding: EdgeInsets.only(bottom: 12),
                                        border: InputBorder.none,
                                        counterText: ''),
                                  ),
                                ),
                              ),
                            ],
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
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                focusNode: focusPhone,
                                controller: _controllerPhone,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focusEmail);
                                },
                                style: TextStyle(
                                    color: text_color,
                                    fontWeight: FontWeight.w400,fontSize: 12.5),
                                decoration: InputDecoration(
                                    hintText: "Phone no.",
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
                                focusNode: focusEmail,
                                controller: _controllerEmail,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                /*onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focus);
                                },*/
                                style: TextStyle(
                                    color: text_color,
                                    fontWeight: FontWeight.w400,fontSize: 12.5),
                                decoration: InputDecoration(
                                    hintText: "Email ID",
                                    hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    border: InputBorder.none,
                                    counterText: ''),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: <Widget>[
                              Container(
                                width: getWidth(context)/2-40,
                                height: 38,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(color: input_border_color,width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(3.3))
                                ),
                                child: Padding(
                                  padding: CommonMethods.textFieldPadding,
                                  child: Text("Date of birth",style: TextStyle(fontSize: 12.5,color: hint_text_color),),
                                ),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width: getWidth(context)/2-40,
                                height: 38,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border: Border.all(color: input_border_color,width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(3.3))
                                ),
                                child: Padding(
                                  padding: CommonMethods.textFieldPadding,
                                  child: Text("Anniversary date",style: TextStyle(fontSize: 12.5,color: hint_text_color),),
                                ),
                              ),
                            ],
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
