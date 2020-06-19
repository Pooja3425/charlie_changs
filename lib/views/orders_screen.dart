import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/order_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
                        Text("Orders",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 8,),
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
                                    //prefixIcon: Icon(Icons.search,color: icon_color,size: 18,),
                                    hintText: "Search orders",
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
                height: getHeight(context)-205,
                padding: EdgeInsets.only(top:20),
                child: ListView(
                  children: <Widget>[
                    orderRowUI(),
                    deliveryRowUI()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget orderRowUI() {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen()));
      },
      child: Container(
        width: getWidth(context),
        child: Padding(
          padding: const EdgeInsets.only(left:30.0,right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("ABCDE12345",style: TextStyle(color: notification_title_color,fontSize: 15,fontWeight: FontWeight.bold),),
                  Text("In Progress",style: TextStyle(color: progress_text_color,fontSize: 13),),
                ],
              ),
              SizedBox(height: 20,),
              Text("Name of dish x 1, Name of dish x 2, Name of dish x 1",style: TextStyle(color: hint_text_color,fontSize: 12),),
              Padding(
                padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
                child: Text("Rs 1,200  (check details)",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
                child: Text("22-Aug-2020 | 8:00 PM  |  Delivery",style: TextStyle(color: hint_text_color,fontSize: 12),),
              ),
              SizedBox(height: 20,),
              Text("repeat order",style: TextStyle(color: button_color,fontSize: 12,),),
              SizedBox(height: 20,),
              CommonMethods.horizontalLine(context)
            ],
          ),
        ),
      ),
    );
  }


  Widget deliveryRowUI() {
    return Container(
      width: getWidth(context),
      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("ABCDE12345",style: TextStyle(color: notification_title_color,fontSize: 15,fontWeight: FontWeight.bold),),
                Text("Delivered",style: TextStyle(color: delivered_text_color,fontSize: 13),),
              ],
            ),
            SizedBox(height: 20,),
            Text("Name of dish x 1, Name of dish x 2, Name of dish x 1",style: TextStyle(color: hint_text_color,fontSize: 12),),
            Padding(
              padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
              child: Text("Rs 1,200  (check details)",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:3.0,bottom: 3.0),
              child: Text("22-Aug-2020 | 8:00 PM  |  Delivery",style: TextStyle(color: hint_text_color,fontSize: 12),),
            ),
            SizedBox(height: 20,),
            Text("repeat order",style: TextStyle(color: button_color,fontSize: 12,),),
            SizedBox(height: 20,),
            CommonMethods.horizontalLine(context)
          ],
        ),
      ),
    );
  }
}
