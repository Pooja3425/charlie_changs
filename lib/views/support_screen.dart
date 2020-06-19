import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _controllerSupport = TextEditingController();
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: PreferredSize(
          preferredSize: Size.fromHeight(74.0),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.keyboard_backspace,color: icon_color,),
                SizedBox(width: 10,),
                Text("Support",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
              ],
            )
          ),
        ),*/
        body: Container(
          width: getWidth(context),
          height: getHeight(context),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                child:  Container(
                color: Colors.white,
                height: 74,
                width: getWidth(context),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right:30.0,left: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.keyboard_backspace,color: icon_color,),
                      SizedBox(width: 10,),
                      Text("Support",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),),
              Positioned(
                top:74,
                bottom: 73,
                child: Container(
                  width: getWidth(context),
                  height: getHeight(context)-148,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[

                          Container(height: 10,color: switch_bg,
                            width: getWidth(context),),
                          Container(
                            width: getWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.only(right:30.0,left: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10,),
                                  Text("Share your feedback",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 15,),
                                  Container(
                                    width: getWidth(context),
                                    //height: 38,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: input_border_color,width: 1.0),
                                        borderRadius: BorderRadius.all(Radius.circular(3.3))
                                    ),
                                    child: Padding(
                                      padding: CommonMethods.textFieldPadding,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        maxLength: 150,
                                        maxLines: 5,
                                        controller: _controllerSupport,
                                        textCapitalization: TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        /*onSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusNewPass);
                                      },*/
                                        style: TextStyle(
                                            color: text_color,
                                            fontWeight: FontWeight.w400,fontSize: 12.5),
                                        decoration: InputDecoration(
                                            hintText: "Typr your message",
                                            hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                            //contentPadding: EdgeInsets.only(bottom: 12),
                                            border: InputBorder.none,
                                            counterText: ''),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:20.0,bottom: 20),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: FloatingActionButton(onPressed: (){
                                        /*Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => OtpScreen() ),
                                      );*/
                                      },
                                        elevation: 10,
                                        backgroundColor: fab_color,
                                        child: Image.asset("assets/images/forword_arrow.png",width: 25,),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(height: 10,color: switch_bg,
                            width: getWidth(context),),
                          Container(
                            width: getWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.only(left:30.0,right: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  Text("Connect with us",style: TextStyle(color: notification_title_color,fontSize: 16,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  CommonMethods.horizontalLine(context),
                                  SizedBox(height: 20,),
                                  Text("Caranzalem Outlet",style: TextStyle(color: notification_title_color,fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("Model's Millennium Vistas, Shop 1, Caranzalem, Goa - 403002 (Opp. Harley Davidson's Showroom)",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 10,),
                                  Text("+91 - 8308800820  |  info@charliechangs.in",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 20,),
                                  CommonMethods.horizontalLine(context),
                                  SizedBox(height: 20,),
                                  Text("Porvorim Outlet",style: TextStyle(color: notification_title_color,fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text("House Number 844, After Gauri Petrol Pump, Porvorim, Goa 403051",style: TextStyle(color: icon_color),),
                                  SizedBox(height: 10,),
                                  Text("+91 - 8308800820  |  info@charliechangs.in",style: TextStyle(color: notification_title_color),),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          Container(height: 10,color: switch_bg,
                            width: getWidth(context),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                width: getWidth(context),
                height: 73,
                color: button_color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Rate your experience",style: TextStyle(color: Colors.white),),
                    SmoothStarRating(
                      rating: rating,
                      isReadOnly: false,
                      size: 20,
                      borderColor: Colors.white,
                      color: Colors.white,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      starCount: 5,
                      allowHalfRating: true,
                      spacing: 2.0,
                      onRated: (value) {
                        print("rating value -> $value");
                        // print("rating value dd -> ${value.truncate()}");
                      },
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
