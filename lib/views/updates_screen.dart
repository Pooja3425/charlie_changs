import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class UpdatesScreen extends StatefulWidget {
  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: switch_bg,
        width: getWidth(context),
       // height: getHeight(context),
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
                    Text("Notifications",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              width: getWidth(context),
              color: switch_bg,
            ),
            Container(
              color: Colors.white,
              width: getWidth(context),
              height: getHeight(context)-172,
              padding: EdgeInsets.only(top: 15),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context,index){
                  return Container(
                    width: getWidth(context),
                    decoration: BoxDecoration(
                        color: Colors.white
                      //borderRadius: BorderRadius.all(Radius.circular(3.3))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:30.0,right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text("Notification Title", style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold,fontFamily: "Manrope"),),
                          SizedBox(height: 15,),
                          Text("Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum\nLorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum", style: TextStyle(fontSize: 12,color: icon_color,fontFamily: "Manrope",fontWeight: FontWeight.normal),),
                          SizedBox(height: 15,),
                          Text("sent on 22-Jan-2020", style: TextStyle(fontSize: 12,color: notification_date_color,fontFamily: "Manrope",fontWeight: FontWeight.normal),),
                          SizedBox(height: 15,),
                          Container(width: getWidth(context),
                            height: 0.5,
                            color: icon_color,),
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
