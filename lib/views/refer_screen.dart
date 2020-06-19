import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class ReferScreen extends StatefulWidget {
  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          width: getWidth(context),
          height: getHeight(context),
          child: Column(
              children: <Widget>[
                CommonMethods.appBar(context, "Refer a Friend"),
                Container(height: 10,color: switch_bg,
                  width: getWidth(context),),
                Column(
                  children: <Widget>[
                    Container(
                      width: getWidth(context),
                      height: getHeight(context)/2+50,
                      child: Stack(
                        children: <Widget>[

                          Positioned(
                              top: 50,
                              left: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("SPREAD\nSOME\nLOVE ",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,fontFamily: "Poppins"),),
                                  SizedBox(height: 30,),
                                  Text("Share your unique\ncoupon code with\nyour friends and\nthey get Rs 50 off\non their first order\nand you get Rs 50",style: TextStyle(fontSize: 12),)
                                ],
                              )),
                          Positioned(
                              top: 50,
                              right: -10,
                              //left: getWidth(context)/2,
                              child: Image.asset("assets/images/refer_img.png",height: 320,width: 197,fit: BoxFit.cover,)),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:30.0,right: 30.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: button_color,
                          borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0,8.0,15.0,8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Your Code - ABCDE12345",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              Row(
                                children: <Widget>[
                                  Image.asset("assets/images/copy.png",height: 20,),
                                  SizedBox(width: 10,),
                                  Image.asset("assets/images/upload.png",height: 20,)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
          ),
        ),
      ),
    );
  }
}
