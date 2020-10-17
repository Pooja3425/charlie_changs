import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'color_constants.dart';
import 'color_constants.dart';
import 'size_constants.dart';

class CommonMethods
{
  TextStyle toolBar = TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold);

  static Widget horizontalLine(BuildContext context)
  {
   return Container(height: 0.2,color: icon_color,
     width: getWidth(context),);
  }

  static Widget appBar(BuildContext context,String title)
  {
    return Container(
      color: Colors.white,
      height: 80,
      width: getWidth(context),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right:30.0,left: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: ()=> Navigator.of(context).pop(),
                child: Icon(Icons.keyboard_backspace,color: icon_color,)),
            SizedBox(width: 10,),
            Text(title,style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }

  Widget thickHorizontalLine(BuildContext context)
  {
    return Container(
      height: 10,
      width: getWidth(context),
      color: switch_bg,
    );
  }

  static void showShortToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }
  static void showLongToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }
  static ProgressDialog pr;
  static displayProgressDialog(String message,BuildContext context)
  {
    print(message);
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      customBody: Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left:15.0,right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularProgressIndicator(
                // semanticsLabel: message,
                valueColor: AlwaysStoppedAnimation<Color>(button_color),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 15,),
              Text(message)
            ],
          ),
        ),
      ),
    );
    pr.show();
  }


  static hideDialog(){
    /*pr.hide().then((isHidden) {
      print(isHidden);
    });*/
    Future.delayed(Duration(seconds: 1)).then((value) {
      pr.hide().whenComplete(() {

      });
    });
  }


 static showLoaderDialog(BuildContext context,String message){
    AlertDialog alert=
    AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(backgroundColor: button_color,valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
          Container(margin: EdgeInsets.only(left: 7),child:Text(message)),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(
            onWillPop: () {},
            child: alert,
          );
      },
    );
  }

  static dismissDialog(BuildContext context){
    Navigator.pop(context);

  }

  static setPreference(BuildContext context,String key, String value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key,value);
  }

  static setPreferenceBool(BuildContext context,String key, bool value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key,value);
  }
  static getPreference(BuildContext context,String key) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.get(key) !=null)
      return prefs.get(key);
  }

  static void clearSharedPrefs(String keydel)async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for(String key in preferences.getKeys()) {
      if(key == keydel) {
        preferences.remove(key);
      }
    }
  }
  static final EdgeInsets textFieldPadding = EdgeInsets.only(left:10.0,right:10.0);
  static final EdgeInsets initialPadding =  const EdgeInsets.only(left:40.0,right: 40);
}