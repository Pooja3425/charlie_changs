import 'package:charliechang/blocs/get_profile_bloc.dart';
import 'package:charliechang/models/get_profile_data.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/change_password_screen.dart';
import 'package:charliechang/views/udate_profile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
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
                      Text("Profile",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              Container(height: 10,color: switch_bg,
                width: getWidth(context),),
              Container(
                width: getWidth(context),
               // height: getHeight(context)-118,
                color: Colors.white,
                padding: EdgeInsets.only(top: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    rowUI("assets/images/profile.png", "Profile Info"),
                    rowUI("assets/images/password.png", "Change Password"),
                    rowUI("assets/images/address.png", "Address Book"),

                  ],
                ),
              )
            ],
          ),
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

  navigate(String menu) {
    if(menu.contains("Profile"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateProfile()),
      );
    }

    if(menu.contains("Change"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
      );
    }
    if(menu.contains("Address"))
    {
      print("ddd");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddressBookScreen()),
      );
    }
  }


}
