import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/cartlistBloc.dart';
import 'views/address_book_screen.dart';
import 'views/bottom_screen.dart';
import 'views/home_screen.dart';
import 'views/payment_fail_screen.dart';
import 'utils/size_constants.dart';
import 'views/checkout_screen.dart';
import 'views/complete_profile_screen.dart';
import 'views/login_screen.dart';
import 'views/otp_screen.dart';
import 'views/pickup_checkout_screen.dart';
import 'views/silver_app_demo.dart';
import 'views/thanks_screen.dart';

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

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    .._matchteam = data['matchteam']
    .._score = data['score'];
  return item;
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _matchteam;
  String get matchteam => _matchteam;
  set matchteam(String value) {
    _matchteam = value;
    _controller.add(this);
  }

  String _score;
  String get score => _score;
  set score(String value) {
    _score = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    /*return routes.putIfAbsent(
      routeName,
          () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );*/
  }
}


const kAndroidUserAgent =
    "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
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
  String selectedUrl = 'https://flutter.io';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        //add yours BLoCs controlles
        Bloc((i) => CartListBloc()),
        //Bloc((i) => ColorBloc()),
      ],
      child: ChangeNotifierProvider<CartBloc>(
        builder: (context) => CartBloc(),
        child: MaterialApp(
          title: 'Charlie changs',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: colorCustom,
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
            '/AddressBookScreen': (BuildContext context) => new AddressBookScreen(),
            '/BottomScreen': (BuildContext context) => new BottomScreen(),
            '/SilverAppBarDemo': (BuildContext context) => new SilverAppBarDemo(),
            '/widget': (_){
              return WebviewScaffold(
                url: selectedUrl,
              );
            }
          },

          home: SplashScreen(),
        ),
      ),
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

  startTimeHome() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationHome);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
    //Navigator.of(context).pushReplacementNamed('/OtpScreen');
  }

  void navigationHome() {
    Navigator.of(context).pushReplacementNamed('/BottomScreen');
    //Navigator.of(context).pushReplacementNamed('/OtpScreen');
  }
  String profile_value;

  @override
  void initState() {

    getValues();


   /* Future complete_profile = CommonMethods.getPreference(context, COMPLETE_PROFILE);
    complete_profile.then((data){
      setState(() {
        profile_value = data;
      });
      if(profile_value == "1")
      {
        startTimeHome();
      }
      else
      {
        startTime();
      }
    });*/

   print("SPLASH check ${token} $complete_profile");

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
                child:Image.asset("assets/images/logo.png",width: 230.3,height: 250,),
              ),
            ],
          ),
        ));
  }

  String token,complete_profile;
   getValues() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
      complete_profile = preferences.getString(COMPLETE_PROFILE);
      print("chrck $token  $complete_profile");

      if(token!=null)
      {
        if(complete_profile == "1")
        {
          startTimeHome();
        }
        else
        {
          startTime();
        }
      }
      else
      {
        startTime();
      }
    });
   }
}
