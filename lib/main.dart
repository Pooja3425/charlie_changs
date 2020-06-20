import 'dart:async';
import 'dart:io';

import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/home_screen.dart';
import 'views/payment_fail_screen.dart';
import 'utils/size_constants.dart';
import 'views/checkout_screen.dart';
import 'views/complete_profile_screen.dart';
import 'views/login_screen.dart';
import 'views/otp_screen.dart';
import 'views/pickup_checkout_screen.dart';
import 'views/thanks_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.latestStyle;
  //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  //SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charlie changs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Manrope"

      ),
      routes: <String, WidgetBuilder>{
        '/LoginScreen': (BuildContext context) => new LoginScreen(),
        '/OtpScreen': (BuildContext context) => new OtpScreen(),
        '/ThanksScreen': (BuildContext context) => new ThanksScreen(),
        '/PaymentFailScreen': (BuildContext context) => new PaymentFailScreen(),
        '/CheckoutScreen': (BuildContext context) => new CheckoutScreen(),
        '/PickupCheckoutScreen': (BuildContext context) => new PickupCheckoutScreen(),
        '/CompleteProfileScreen': (BuildContext context) => new CompleteProfileScreen(),
        '/HomeScreen': (BuildContext context) => new HomeScreen(),
      },
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
  }

  void navigationHome() {
    Navigator.of(context).pushReplacementNamed('/BottomScreen');
  }
  String profile_value;
  @override
  void initState() {
    Future complete_profile = CommonMethods.getPreference(context, COMPLETE_PROFILE);
    complete_profile.then((data){
      setState(() {
        profile_value = data;
      });
      if(profile_value == "1")
      {
        navigationHome();
      }
      else
      {
        startTime();
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: getWidth(context),
          height: getHeight(context),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/splash_bg.png"),fit: BoxFit.cover)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child:Image.asset("assets/images/splash_img.png",width: 156.3,height: 45,),
              ),
            ],
          ),
        ));
  }
}
