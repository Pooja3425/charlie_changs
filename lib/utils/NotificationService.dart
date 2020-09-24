import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class  NotificationService {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _fcl = FlutterLocalNotificationsPlugin();

  BuildContext context;
  GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription _iosSubscription;

  Future initialise(BuildContext context,GlobalKey<NavigatorState> navigatorKey) async {

    //print("notifications init called");

    this.context = context;
    this.navigatorKey = navigatorKey;

    if(Platform.isIOS){
      _iosSubscription = _fcm.onIosSettingsRegistered.listen((data){
        //_checkToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());

    }
    //_checkToken();

    _fcm.configure(

      onMessage: (Map<String , dynamic> message) async {
        print("on message : $message");

        _showLocalNoti(message);
      },

      onLaunch: (Map<String , dynamic> message) async {

        print("on Laung : $message");

        checkData(message, context);

      },

      onResume: (Map<String , dynamic> message) async {

        print("on resure = == == == = === ==  : $message");

        checkData(message, context);

      },


      //onBackgroundMessage: myBackgroundMessageHandler

    );

    _initLocalNotification();

  }

  checkData(Map<String , dynamic> message , BuildContext context) async{

    if(message['data'] != null){
      if(message['data']['n_type'] != null){

        if(message['data']['n_type'] =="order")
        {
          print("Order BACKGROUND");
          await navigatorKey.currentState.push(
              MaterialPageRoute(builder: (_) =>  OrdersScreen(from: "bottom",))
          );
        }
        else {
          print("update BACKGROUND");
          await navigatorKey.currentState.push(
              MaterialPageRoute(builder: (_) => BottomScreen(initPage: 3,),));
        }

      }
    }

  }

  Future<String> getDeToken(){

    return _fcm.getToken();

  }

  _initLocalNotification(){

    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android , ios);

    _fcl.initialize(platform , onSelectNotification: onSelectNotification);
  }

  _showLocalNoti(message) async {

    var android = AndroidNotificationDetails(
      "channel_id" , "CHANNEL NAME" , "channel desc"
    );
    var ios = IOSNotificationDetails();
    var platfrom = NotificationDetails(android , ios);

    var rng = new Random();
    int id = rng.nextInt(40);

    _fcl.show(id, "${message['notification']['title']}",
        "${message['notification']['body']}", platfrom , payload: message['data']['n_type'].toString());


  }


  Future onSelectNotification(String payload) async {


    print("payload is == $payload");

    if(payload != null){

      if(payload.isNotEmpty){

        if(payload.contains("order"))
        {
          print("order redi FOREGROUND");
          await navigatorKey.currentState.push(
              MaterialPageRoute(builder: (_) => OrdersScreen(from: "bottom",),));
        }
        else {
          print("update FOREGROUND");
          await navigatorKey.currentState.push(
              MaterialPageRoute(builder: (_) => BottomScreen(initPage: 3,),));
        }

      }

    }

  }

}
