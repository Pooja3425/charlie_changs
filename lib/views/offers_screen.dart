import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: switch_bg,
        width: getWidth(context),
        height: getHeight(context),
        child: Column(
          children: <Widget>[
            Container(
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
                    Text("Offers For You",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),

            Container(
              width: getWidth(context),
              height: getHeight(context)-162,
              padding: EdgeInsets.only(top: 30),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30.0),
                    child: Container(
                      width: getWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.3))
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.3))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: getWidth(context),
                                child: Image.asset("assets/images/dish2.png",height: 150,fit: BoxFit.cover,)),

                            Padding(
                              padding: const EdgeInsets.only(right:20.0,left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  Text("Flat 10% Off on all online orders",
                                    style: TextStyle(fontSize: 15,color: fab_color,fontFamily: "Manrope",fontWeight: FontWeight.bold),),
                                  Text("Minimum order value of Rs 300. Maximum discount \nof Rs 100, Valid till 31st December 2020",
                                    style: TextStyle(color: icon_color,fontSize: 13),),
                                  SizedBox(height: 15,),
                                  Row(children: <Widget>[
                                    Text("use code",style: TextStyle(color: icon_color,),),
                                    SizedBox(width: 20,),
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: fab_color,
                                        borderRadius: BorderRadius.all(Radius.circular(3.3))
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right:15,left:15),
                                          child: Text("CHARLIE10",style: TextStyle(color: Colors.white,fontSize: 12),),
                                        ),
                                      ),
                                    )
                                  ],),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
