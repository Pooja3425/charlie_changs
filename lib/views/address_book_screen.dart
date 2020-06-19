
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/add_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AddressBookScreen extends StatefulWidget {
  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: AppBar(
            elevation: 0.0,
              automaticallyImplyLeading: false,
              flexibleSpace:  Container(
                color: Colors.white,
                //height: 107,
                width: getWidth(context),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right:30.0,left: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: ()=>Navigator.of(context).pop(),
                              child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                          SizedBox(width: 10,),
                          Text("Address Book",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 40,
                        width: getWidth(context),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: switch_bg,
                            borderRadius: BorderRadius.all(Radius.circular(3))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //Icon(Icons.search,color: icon_color,size: 18,),
                              SizedBox(width: 3,),
                              Icon(Icons.search,color: icon_color,size: 18,),
                              SizedBox(width: 3,),
                              Container(
                                width: getWidth(context)-110,
                                child: TextField(
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                      //contentPadding: EdgeInsets.only(top: 5),
                                     // prefixIcon: Icon(Icons.search,color: icon_color,size: 18,),
                                      hintText: "Search for adresses",
                                      hintStyle: TextStyle(fontSize: 12,color: icon_color),
                                      //contentPadding: EdgeInsets.only(bottom: 3),
                                      border: InputBorder.none,
                                      counterText: ''
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: Container(
          width: getWidth(context),

          child:Column(
            children: <Widget>[

              Container(height: 10,color: switch_bg,
                width: getWidth(context),),
              Container(
                width: getWidth(context),
                height: 47,
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAddressScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("+  Add New Address",style: TextStyle(fontSize: 12,color: fab_color,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ),
              Container(height: 10,color: switch_bg,
                width: getWidth(context),),
              Container(
                width: getWidth(context),
                height: getHeight(context)-210,
                padding: EdgeInsets.only(top:15),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    addressRouUI(),
                    addressRouUI(),
                    addressRouUI(),
                    addressRouUI(),
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
          Text("Home",style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text("A-302, Blooming Dales Apartment,  Near Jupiter\nHospital, Opposite De Ballio restaurant, Baner, Pune",style: TextStyle(fontSize: 12,color: notification_title_color),),
          SizedBox(height: 10,),
          Text("Edit",style: TextStyle(fontSize: 12,color: fab_color,fontWeight: FontWeight.w600),),
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
