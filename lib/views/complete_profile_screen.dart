import 'dart:convert';

import 'package:charliechang/blocs/complete_profile_bloc.dart';
import 'package:charliechang/models/complete_profile_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:flutter/material.dart';

import '../utils/common_methods.dart';
import 'bottom_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerReferral = TextEditingController();

  final focusEmail = FocusNode();
  final focusReferral = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: getWidth(context),
        height: getHeight(context),
        child: Padding(
          padding: const EdgeInsets.only(left:30.0,right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Complete Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
                    keyboardType: TextInputType.text,
                    maxLength: 30,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    controller: controllerName,
                    style: TextStyle(
                      // color: heading_color,
                        fontWeight: FontWeight.w300,fontSize: 13),
                    decoration: InputDecoration(
                        hintText: "Enter your name",
                        hintStyle: TextStyle(fontSize: 13),
                        //contentPadding: EdgeInsets.only(bottom: 3),
                        border: InputBorder.none,
                        counterText: ''),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: getWidth(context),
                //height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: input_border_color,width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(3.3))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    //maxLength: 50,
                    focusNode: focusEmail,
                    controller: controllerEmail,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focusReferral);
                                },
                    style: TextStyle(
                        color: text_color,
                        fontWeight: FontWeight.w400,fontSize: 13),
                    decoration: InputDecoration(
                        hintText: "Enter email ID",
                        hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                       // contentPadding: EdgeInsets.only(bottom: 12),
                        border: InputBorder.none,
                        counterText: ''),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: getWidth(context),
                //height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: input_border_color,width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(3.3))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 15,
                    focusNode: focusReferral,
                    controller: controllerReferral,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    /*onSubmitted: (v){
                                  FocusScope.of(context).requestFocus(focus);
                                },*/
                    style: TextStyle(
                        color: text_color,
                        fontWeight: FontWeight.w400,fontSize: 12.5),
                    decoration: InputDecoration(
                        hintText: "Enter Referral Code",
                        hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                        //contentPadding: EdgeInsets.only(bottom: 12),
                        border: InputBorder.none,
                        counterText: ''),
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(onPressed: (){

                  if(isValid())
                    {
                        callAPI();
                    }

                },
                  elevation: 10,
                  backgroundColor: fab_color,
                  child: Image.asset("assets/images/forword_arrow.png",width: 25,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValid() {
    if(controllerName.text.length==0){
      CommonMethods.showShortToast("Please enter name");
      return false;
    }
    if(controllerEmail.text.length==0){
      CommonMethods.showShortToast("Please enter email");
      return false;
    }
    return true;
  }

  CompleteProfieBloc mCompleteProfieBloc;
  CompleteProfileResponse mCompleteProfileResponse;
  Map<String, dynamic> bodyData;
  callAPI() {
//    bodyData={
//      "name":controllerName.text,
//      "email":controllerEmail.text,
//      "referral":controllerReferral.text
//    };


    final body = jsonEncode({"name":controllerName.text,"email":controllerEmail.text,"referral":controllerReferral.text});

    mCompleteProfieBloc=CompleteProfieBloc(body);
    mCompleteProfieBloc.dataStream.listen((onData){
      mCompleteProfileResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mCompleteProfileResponse.msg);
        CommonMethods.setPreference(context, COMPLETE_PROFILE, "1");

        if(mCompleteProfileResponse.msg!="Token not exist!")
          {
            navigateToAddAddress();
          }
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }
  void navigateToAddAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressBookScreen()),
    );
  }
}
