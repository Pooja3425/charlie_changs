import 'package:charliechang/networking/ApiProvider.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
              url: "${ApiProvider.BASE_URL_FOR_WEB}about",
              appBar: appBar(context, "About"),
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  appBar(BuildContext context, String s) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        color: Colors.white,
        // height: 80,
        width: getWidth(context),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(right: 30.0, left: 30.0, top: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: icon_color,
                  )),
              SizedBox(
                width: 10,
              ),
              Text(
                s,
                style: TextStyle(
                    color: text_color,
                    fontSize: 15,
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
