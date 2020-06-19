import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/points_screen.dart';
import 'package:charliechang/views/profile_screen.dart';
import 'package:charliechang/views/refer_screen.dart';
import 'package:charliechang/views/support_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'orders_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
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
                    Text("More Settings",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            Container(height: 10,color: switch_bg,
            width: getWidth(context),),
            Container(
              width: getWidth(context),
              height: getHeight(context)-172,
              color: Colors.white,
              padding: EdgeInsets.only(top: 10),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  rowUI("assets/images/profile.png", "Profile"),
                  rowUI("assets/images/cart.png", "Orders"),
                  rowUI("assets/images/points.png", "Loyalty Points"),
                  rowUI("assets/images/refer.png", "Refer a Friend"),
                  rowUI("assets/images/support.png", "Support"),
                  rowUI("assets/images/about.png", "About"),
                  rowUI("assets/images/logout.png", "Logout"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rowUI(String imageName,String menu)
  {
    return InkWell(
      onTap: ()=>navigate(menu),
      child: Container(
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
              SizedBox(height: 25,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(imageName,width: 15,height: 15,),
                      SizedBox(width: 15,),
                      Container(
                        width: getWidth(context)-100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(menu, style: TextStyle(fontSize: 12,color: menu!="Logout"?notification_date_color:fab_color,fontFamily: "Manrope",fontWeight: FontWeight.normal),),
                            Image.asset("assets/images/next.png",width: 15,height: 15,),
                          ],
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 15),
                    child: Container(width: getWidth(context),
                      height: 0.5,
                      color: icon_color,),
                  ),
                  menu!="Logout"?Container():SizedBox(height: 25,),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  navigate(String s) {

    print(s);
    if(s.contains("Profile"))
      {
        print("ddd");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      }

    if(s.contains("Support"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupportScreen()),
      );
    }

    if(s.contains("Refer"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReferScreen()),
      );
    }

    if(s.contains("Orders"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );
    }
    if(s.contains("Points"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PointsScreen()),
      );
    }
  }
}
