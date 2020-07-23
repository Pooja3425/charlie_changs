
import 'dart:async';
import 'dart:convert';

import 'package:charliechang/blocs/get_profile_bloc.dart';
import 'package:charliechang/blocs/update_profile_bloc.dart';
import 'package:charliechang/models/get_profile_data.dart';
import 'package:charliechang/models/update_profile.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        callProfileAPI();
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

  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime date, _todayDate;
  String dobString="";
  String aniDate="";
  Future _selectDate() async {
    print('picked  ${DateTime(1985)}');
    DateTime picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: new DateTime.now() ,
      firstDate:new DateTime(1985),
      lastDate: DateTime.now(),
    );
    // if(picked != null) setState(() => _datevalue = new DateFormat("MM/dd/yyyy").parse( picked.toString()));
    if (picked != null) {
      // var date = new DateFormat("MM/dd/yyyy").parse(picked.toString());
      setState(() {
        date = picked;
        dobString='${myFormat.format(date)}';
      //  _controllerDOB.text = '${myFormat.format(date)}';
        // nextHearingDate = '${myFormat.parse(date.toString())}';
      });
    }
    print('date $date');
  }

  Future _aniverseryDate() async {
    print('picked  ${DateTime(1985)}');
    DateTime picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: new DateTime.now() ,
      firstDate:new DateTime(1985),
      lastDate: DateTime.now(),
    );
    // if(picked != null) setState(() => _datevalue = new DateFormat("MM/dd/yyyy").parse( picked.toString()));
    if (picked != null) {
      // var date = new DateFormat("MM/dd/yyyy").parse(picked.toString());
      setState(() {
        date = picked;
        aniDate='${myFormat.format(date)}';
        //  _controllerDOB.text = '${myFormat.format(date)}';
        // nextHearingDate = '${myFormat.parse(date.toString())}';
      });
    }
    print('date $date');
  }

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
                              InkWell(
                                onTap: ()=>_selectDate(),
                                child: Container(
                                  width: getWidth(context)/2-40,
                                  height: 38,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: input_border_color,width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                                  ),
                                  child: Padding(
                                    padding: CommonMethods.textFieldPadding,
                                    child: Text(dobString==""?"Date of birth":dobString,style: TextStyle(fontSize: 12.5,color: hint_text_color),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: ()=>_aniverseryDate(),
                                child: Container(
                                  width: getWidth(context)/2-40,
                                  height: 38,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: input_border_color,width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                                  ),
                                  child: Padding(
                                    padding: CommonMethods.textFieldPadding,
                                    child: Text(aniDate==""?"Anniversary date":aniDate,style: TextStyle(fontSize: 12.5,color: hint_text_color),),
                                  ),
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
                  child: InkWell(
                    onTap: (){
                      if(_isInternetAvailable)
                        {
                          callUpdateService();
                        }
                      else
                        {
                          CommonMethods.showLongToast(CHECK_INTERNET);
                        }
                    },
                    child: Container(
                width: getWidth(context),
                height: 73,
                color: button_color,
                      child: Center(
                        child: Text("Update Details",style: TextStyle(color: Colors.white),),
                      ),
              ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  GetProfileBloc mGetProfileBloc;
  GetProfileData mGetProfileData;

  callProfileAPI() {
    // final body = jsonEncode({"feedback":_controllerSupport.text,"rating":rating_val.toString()});
    mGetProfileBloc=GetProfileBloc();
    mGetProfileBloc.dataStream.listen((onData){
      mGetProfileData = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);
        _controllerFirstName.text= mGetProfileData.data.firstName;
        _controllerLastName.text= mGetProfileData.data.lastName;
        _controllerEmail.text= mGetProfileData.data.email;
        _controllerPhone.text= mGetProfileData.data.mobile;
        _controllerEmail.text= mGetProfileData.data.email;
        if(mGetProfileData.data.dob!=null && mGetProfileData.data.dob!="0000-00-00")
          {
            setState(() {

              dobString = mGetProfileData.data.dob;

            });
          }

        if(mGetProfileData.data.annDob!=null && mGetProfileData.data.annDob!="0000-00-00")
        {
          setState(() {


            aniDate = mGetProfileData.data.annDob;
          });
        }


        //navigationPage();
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }


  UpdateProfileBloc mUpdateProfileBloc;
  UpdateProfileResponse mUpdateProfileResponse;
  var dob,ann;
   callUpdateService() {
     var inputFormat = DateFormat("dd-MM-yyyy");
     var outputFormat = DateFormat("yyyy-MM-dd");
     if(dobString!="")
       {
         var DOBdate = inputFormat.parse(dobString);
         dob = outputFormat.parse("$DOBdate");
       }

     if(aniDate!="")
       {
         var Anndate = inputFormat.parse(aniDate);
         ann = outputFormat.parse("$Anndate"); // 2019-08-18
       }



     final body = jsonEncode({"first_name":_controllerFirstName.text,
        "last_name":_controllerLastName.text,
        "email":_controllerEmail.text,
        "dob":dobString!=""?dob.toString():"",
        "ann_dob":aniDate!=""?ann.toString():"",
      });
     mUpdateProfileBloc=UpdateProfileBloc(body);
     mUpdateProfileBloc.dataStream.listen((onData){
       mUpdateProfileResponse = onData.data;
       //print(onData.status);
       if(onData.status == Status.LOADING)
       {
         // CommonMethods.displayProgressDialog(onData.message,context);
         CommonMethods.showLoaderDialog(context,onData.message);
       }
       else if(onData.status == Status.COMPLETED)
       {
         CommonMethods.dismissDialog(context);
         CommonMethods.showLongToast(mUpdateProfileResponse.msg);
         //navigationPage();
       }
       else if(onData.status == Status.ERROR)
       {
         CommonMethods.dismissDialog(context);
         CommonMethods.showShortToast(onData.message);

       }
     });

   }
}
