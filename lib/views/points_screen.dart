
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            flexibleSpace: CommonMethods.appBar(context, "Loyalty Points"),
          ),
        ),
         body: Container(
            width: getWidth(context),
            child: Column(
              children: <Widget>[
                Container(
                  width: getWidth(context),
                  height: 10,
                  color: switch_bg,
                ),
                Container(
                  //width: getWidth(context),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15,),
                      Text("You have",style: TextStyle(color: icon_color),),
                      Text("500 points",style: TextStyle(color: button_color,fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: input_border_color,width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: Center(
                          child: Text("Learn how to redeem",style: TextStyle(color: icon_color,fontSize: 12),),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: getWidth(context),
                  height: 10,
                  color: switch_bg,
                ),
                Container(
                  width: getWidth(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30,top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Transaction History",style: TextStyle(fontWeight: FontWeight.bold,color: notification_title_color),),
                        SizedBox(height: 20,),
                        CommonMethods.horizontalLine(context),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Date",style: TextStyle(fontSize: 12,color: hint_text_color),),
                              Text("CR/DR",style: TextStyle(fontSize: 12,color: hint_text_color),),
                              Text("Points",style: TextStyle(fontSize: 12,color: hint_text_color),)
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          width: getWidth(context),
                          height: getHeight(context)-392,

                          child: ListView.builder(
                              itemCount: 11,
                              itemBuilder: (context,index){
                            return Container(
                              height: 50,
                              width: getWidth(context),
                              decoration: BoxDecoration(
                                  color: index%2!=0?null:switch_bg,
                                  borderRadius: BorderRadius.all(Radius.circular(3))),

                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("22-Aug-20",style: TextStyle(fontSize: 12,color: hint_text_color),),
                                    Text("CR",style: TextStyle(fontSize: 12,color: hint_text_color),),
                                    Text("+200",style: TextStyle(fontSize: 12,color: hint_text_color),)
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                  ),
                )

              ],
            ),
         ),
      ),
    );
  }
}
