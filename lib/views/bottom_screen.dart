import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/cart_bloc.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/utils/NotificationPlugin.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/cart_screen.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:charliechang/views/offers_screen.dart';
import 'package:charliechang/views/order_detail_screen.dart';
import 'package:charliechang/views/updates_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'more_screen.dart';


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("in background");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class BottomScreen extends StatefulWidget {
  int initPage;
  BottomScreen({this.initPage});
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  PageController _pageController;
  int _page=0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {

    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/logo');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    _pageController = new PageController();
    if(widget.initPage!=null)
      {
        setState(() {
          _page=widget.initPage;

        });
      }
      getCartValue();

    _firebaseMessaging.getToken().then((value) => print("TOKEN $value"));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        /*Platform.isAndroid
            ? showNotification(message['notification'])
            : showNotification(message['aps']['alert']);*/
        Platform.isAndroid
            ? notificationPlugin.showNotification(message["notification"])
            : notificationPlugin.showNotification(message['aps']['alert']);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: ${message.values}");
       setState(() {
         _page = 3;
         _pageController.jumpToPage(_page);
       });
        //_navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
    super.initState();
  }

  Future onSelectNotification(String payload) {
   print("payloadd $payload");
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');

  }

  void onPageChanged(int page){
    setState(() {
      this._page = page;
    });

  }
  String appBarTitle = 'Dashboard';
  void navigationTapped(int page) {
    print("SSS $page");
    if (page == 0) {
      appBarTitle = 'Dashboard';
    }
    else if (page == 1) {
      appBarTitle = 'Announcements';
    }
    else if (page == 2) {
      appBarTitle = 'Personal Profile';
      if(count>0)
      goToCheckout();

    }
    else if (page == 3) {
      appBarTitle = 'Sync Cases';
    }

    // Animating to the page.
    // You can use whatever duration and curve you like

    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
  bool showBadge= true;
  static int badgeData = 0;
  int count=0;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _page ==0?exitDialog:goToHome,
      child: Scaffold(
        body: Container(
          height: getHeight(context),
          child: IndexedStack(
            children: <Widget>[
              new PageView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  new HomeScreen(
                    callback1: () {
                      showBadge = true;
                      setState(() {});
                    },
                    func1: (string) {
                      if (string == 'ADD') {
                        badgeData++;
                      } else if (string == 'REMOVE') {
                        badgeData--;
                      }
                      setState(() {});
                    },
                  ),
                  new OffersScreen(),
                  new CartScreen(
                    callback1: () {
                      showBadge = true;
                      setState(() {});
                    },
                    func1: (string) {
                      if (string == 'ADD') {
                        badgeData++;
                      } else if (string == 'REMOVE') {
                        badgeData--;
                      }
                      setState(() {});
                    },
                  ),
                  new UpdatesScreen(),
                  new MoreScreen()
                ],
                onPageChanged: onPageChanged,
                controller: _pageController,
              ),
            ],
          ),
        ),
        bottomNavigationBar: new Theme(
          isMaterialAppTheme: false,
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: const Color(0xFFFFFFFF),
          ), // sets the inactive color of the `BottomNavigationBar`
          child: new BottomNavigationBar(
            selectedItemColor: fab_color,
            unselectedItemColor: icon_color,
            type: BottomNavigationBarType.fixed,
            items: [
              new BottomNavigationBarItem(
                  icon:  Image.asset(
                    'assets/images/home.png', height: 15, width: 15,color: _page==0?fab_color:icon_color,),
                  title: new Text(
                    "Home",style: TextStyle(color: _page==0?fab_color:icon_color,fontSize: 12),
                  )),

              new BottomNavigationBarItem(
                  icon:  Image.asset(
                    'assets/images/offers.png', height: 15,
                    width: 15,color: _page==1?fab_color:icon_color,),
                  title: new Text(
                    "offers",style: TextStyle(color: _page==1?fab_color:icon_color,fontSize: 12),

                  )),
              new BottomNavigationBarItem(
                  icon: StreamBuilder(
                    stream: bloc.listStream,
                    builder: (context,snapshot){
                      if(snapshot.hasData)
                        {
                          int quantity=0;
                          List<Menu>foodItems = snapshot.data;
                          for(int i=0;i<foodItems.length;i++)
                            {
                              quantity=quantity+foodItems[i].count;
                              count = quantity;
                            }
                          return Badge(
                            shape: BadgeShape.circle,
                            badgeContent: Text(
                              "${quantity}",
                              style: TextStyle(color: Colors.white,fontSize: 10),
                            ),
                            child: Image.asset(
                              'assets/images/cart.png', height: 15, width: 15,color: _page==2?fab_color:icon_color,),
                          );
                        }
                      else
                        {
                          return Badge(
                            shape: BadgeShape.circle,
                            badgeContent: Text(
                              "${badgeData}",
                              style: TextStyle(color: Colors.white,fontSize: 10),
                            ),
                            child: Image.asset(
                              'assets/images/cart.png', height: 15, width: 15,color: _page==2?fab_color:icon_color,),
                          );
                        }
                    },
                   /* child: Badge(
                      shape: BadgeShape.circle,
                      badgeContent: Text(
                        badgeData.toString(),
                        style: TextStyle(color: Colors.white,fontSize: 10),
                      ),
                      child: Image.asset(
                        'assets/images/cart.png', height: 15, width: 15,color: _page==2?fab_color:icon_color,),
                    ),*/
                  ),
                  title: new Text(
                    "Cart",style: TextStyle(color: _page==2?fab_color:icon_color,fontSize: 12),

                  )),
              new BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/updates.png', height: 15,
                    width: 15,color: _page==3?fab_color:icon_color,),
                  title: new Text(
                    "Updates",style: TextStyle(color: _page==3?fab_color:icon_color,fontSize: 12),
                  )),
              new BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/more.png', height: 15,
                    width: 15,color: _page==4?fab_color:icon_color,),
                  title: new Text(
                    "More",style: TextStyle(color: _page==4?fab_color:icon_color,fontSize: 12),
                  )),
            ],
           onTap: navigationTapped,
            /*onTap: (index) {
              setState(() {
                _page = index;
              });
            },*/
            currentIndex: _page,


            //selectedItemColor: Colors.amber[800],

          ),
        ),
      ),
    );
  }

  Future<bool> goToHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
  }

  goToCheckout()
  {
    if(mounted)
    {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(),));
    }
  }
  Future<bool> exitDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0)), //this right here
            child: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(height: 35),
                        Text("Are you sure you want exit?",textAlign: TextAlign.center,style: TextStyle(color: notification_title_color,fontWeight: FontWeight.bold,fontSize: 15),),
                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: getWidth(context),
                      height: 35,
                      decoration: BoxDecoration(
                          color: button_color,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0),bottomLeft: Radius.circular(10.0))
                      ),
                      child: Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                              onTap: (){
                                Navigator.of(context).pop(true);
                                SystemNavigator.pop();
                              },
                              child: Text("Yes, exit me ",style: TextStyle(color: Colors.white,fontSize: 12),)),
                          Container(
                              height: 13,
                              child: VerticalDivider(width: 1,thickness: 1,color: Colors.white,)),
                          InkWell(
                              onTap: (){
                                Navigator.of(context).pop(false);
                              },
                              child: Text("No, I will stay",style: TextStyle(color: Colors.white,fontSize: 12),)),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

   getCartValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //badgeData = int.parse(prefs.getString(CART_COUNT));
    });
   }
}
