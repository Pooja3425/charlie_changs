import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferScreen extends StatefulWidget {
  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  String coupon_code;
  @override
  void initState() {
    getCoupon();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(child:  appBar(context, "Refer a Friend"), preferredSize: Size.fromHeight(80)),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            width: getWidth(context),
            height: getHeight(context),
            child: Column(
                children: <Widget>[

                  Container(height: 10,color: switch_bg,
                    width: getWidth(context),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: getWidth(context),
                        height: getHeight(context)/2+50,
                        child: Stack(
                          children: <Widget>[

                            Positioned(
                                top: 40,
                                left: 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("SPREAD\nSOME\nLOVE ",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,fontFamily: "Poppins"),),
                                    SizedBox(height: 30,),
                                    Text("Share your unique\ncoupon code with\nyour friends and they\nget 1000 Loyalty points\non their first order and\nyou get 500 Loyalty points",style: TextStyle(fontSize: 12),)
                                  ],
                                )),
                            Positioned(
                                top: 40,
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
                                Text("Your Code - ${coupon_code}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: (){
                                          Clipboard.setData(new ClipboardData(text: coupon_code));
                                          CommonMethods.showLongToast("Copied to clipboard");
                                         /* Scaffold.of(context).showSnackBar(SnackBar
                                            (content: Text('text copied')));*/
                                        },
                                        child: Image.asset("assets/images/copy.png",height: 20,)),
                                    SizedBox(width: 10,),
                                    InkWell(

                                        onTap:() {
                                          share();
                                        },
                                        child: Image.asset("assets/images/upload.png",height: 20,))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("How to redeem",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),),
                            SizedBox(height: 8,),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                                ),SizedBox(width: 5,),
                                Flexible(child: Text("Copy the referral code shared by your friend.",style: TextStyle(color: Colors.black),)),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                                  ),
                                ),SizedBox(width: 5,),
                                Flexible(child: Text('On the checkout page, select "Apply Coupon Code", paste the referral code, and "Apply" ',style: TextStyle(color: Colors.black),)),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                                  ),
                                ),SizedBox(width: 5,),
                                Flexible(child: Text("Once your order is delivered, you will get the referral points under Loyalty section",style: TextStyle(color: Colors.black),)),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(shape: BoxShape.circle,color: fab_color),
                                  ),
                                ),SizedBox(width: 5,),
                                Text("Can be availed on your first order only.",style: TextStyle(color: Colors.black),),
                              ],
                            ),
                            SizedBox(height: 8,),
                          ],
                        ),
                      )
                    ],
                  )
                ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'
    );
  }

   getCoupon() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coupon_code=prefs.getString(COUPON_CODE);
    });
   }
  Widget appBar(BuildContext context,String title)
  {
    return Container(
      color: Colors.white,
      height: 80,
      width: getWidth(context),
      alignment: Alignment.center,
      child: Align(
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
      ),
    );
  }
}
