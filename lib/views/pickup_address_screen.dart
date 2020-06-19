import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class PickupAddressScreen extends StatefulWidget {
  @override
  _PickupAddressScreenState createState() => _PickupAddressScreenState();
}

class _PickupAddressScreenState extends State<PickupAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CommonMethods.appBar(context, "Select Outlet for Pickup"),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
                width: getWidth(context),
                color: switch_bg,
              ),
              Container(
                width: getWidth(context),
                height: getHeight(context)-122,
                padding: EdgeInsets.only(top:15),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    addressRouUI(),
                    addressRouUI(),
                    ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addressRouUI() {
    return Padding(
      padding: const EdgeInsets.only(left:30.0,right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 10,),
          Text("Caranzalem Outlet",style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("A-302, Blooming Dales Apartment,  Near Jupiter\nHospital, Opposite De Ballio restaurant, Baner, Pune",style: TextStyle(fontSize: 12,color: notification_title_color),),
          SizedBox(height: 10,),
          Text("Find us on map",style: TextStyle(fontSize: 12,color: fab_color,fontWeight: FontWeight.w600),),
          SizedBox(height: 15,),
          Container(width: getWidth(context),
            height: 0.5,
            color: icon_color,),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
