import 'dart:convert';

import 'package:charliechang/models/payment_request.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://flutter.io';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

/*class PayScreen extends StatefulWidget {
  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {

  String url;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => new MyHomePage(),
        '/widget': (_) {
          return WebviewScaffold(
            url: selectedUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            appBar: AppBar(
              title: const Text('Widget WebView'),
            ),
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Text('Waiting.....'),
              ),
            ),

          );
        },
      },
    );
  }



}*/

class PayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => new MyHomePage(),
        '/widget': (_) {
          return WebviewScaffold(
            url: selectedUrl,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            appBar: AppBar(
              title: const Text('Widget WebView'),
            ),
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Text('Waiting.....'),
              ),
            ),

          );
        },
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    createRequest();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.contains(
            'http://www.example.com/redirect')) {
          Uri uri = Uri.parse(url);
//Take the payment_id parameter of the url.
          String paymentRequestId = uri.queryParameters['payment_id'];
//calling this method to check payment status
          _checkPaymentStatus(paymentRequestId);
        }
        else{
          print("ELSE");
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  final flutterWebviewPlugin = new FlutterWebviewPlugin();


  Future createRequest() async {

    Map<String, String> body = {
      "amount": "10", //amount to be paid
      "purpose": "Advertising",
      "buyer_name": "Pooja",
      "email": "poojajadhav130@gmail.com",
      "phone": "8208282138",
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "http://www.example.com/redirect/"
      //Where to redirect after a successful payment.
      //"webhook": "http://www.example.com/webhook/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.encodeFull("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_8338f3d1e94dd539eecfec357cb",
          "X-Auth-Token": "test_86f3567ae710bfb0eba0dbad138"
        },
        body: body);
    print("DDD${json.decode(resp.body)['success']}");
    print("ssssDDD${resp.body.toString()}");
    var data = json.decode(resp.body);
    var rest = data["payment_request"];

   // PaymentRequest pay =  rest.map<PaymentRequest>((json) => PaymentRequest.fromJson(json));
    print("OOO${rest['longurl']}");
    //print("ssssDDD${json.decode(resp.body)["payment_request"['longurl']]}");
    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      String longURL = rest['longurl']+
          "?embed=form";
      String selectedUrl = longURL;
      flutterWebviewPlugin.close();
      print("$selectedUrl");
//Let's open the url in webview.
      flutterWebviewPlugin.launch(selectedUrl);
    }
    else
    {
      CommonMethods.showLongToast(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        Uri.encodeFull("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_8338f3d1e94dd539eecfec357cb",
          "X-Auth-Token": "test_86f3567ae710bfb0eba0dbad138"
        });
    var realResponse = json.decode(response.body);
    print("SUCC $realResponse");
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
//payment is successful.
      flutterWebviewPlugin.close();

      } else {
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }
}

