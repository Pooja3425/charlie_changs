import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/thanks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(83),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              color: Colors.white,
              height: 85,
              width: getWidth(context),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right:30.0,left: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: ()=> Navigator.of(context).pop(),
                            child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                        SizedBox(width: 10,),
                        Text("ABCDE12345",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:33.0,top: 5),
                      child: Text("22-Aug-2020 | 8:00pm",style: TextStyle(fontSize: 13,color: hint_text_color),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ThanksScreen()));
          },
          child: Container(
            height: 78,
            width: getWidth(context),
            color: button_color,
            child: Center(
              child: Text("Repeat Order",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600 ),),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: getWidth(context),
            child: Column(
              children: <Widget>[
                CommonMethods().thickHorizontalLine(context),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2  ,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30.0),
                    child: Container(
                      width: getWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: Text("Name of dish",style: TextStyle(fontSize: 12,color: notification_title_color)),
                              width: getWidth(context)/2-70,
                            ),
                            Text("X 2",style: TextStyle(fontSize: 12,color: notification_title_color)),
                            Padding(
                              padding: const EdgeInsets.only(right:8.0),
                              child: Text("Rs 895",style: TextStyle(fontSize: 12,color: notification_title_color)),
                            )

                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 30.0),
                  child: Column(
                    children: <Widget>[
                      CommonMethods.horizontalLine(context),
                      SizedBox(height: 10,),
                      billUI("Item Total","Rs 1790"),
                      billUI("Discount","Rs 300"),
                      billUI("Taxes","Rs 179"),
                      billUI("Delivery charge","Rs 30"),
                      SizedBox(height: 20,),
                      CommonMethods.horizontalLine(context),
                      billUI("Net Payable","Rs 1699"),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
                CommonMethods().thickHorizontalLine(context),
                Container(
                  width: getWidth(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0,20,30,20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Delivered to HOME",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                        SizedBox(height: 8,),
                        Text("A-302, Blooming Dales Apartment,  Near Jupiter \nHospital, Opposite De Ballio restaurant, Baner, Pune",style: TextStyle(fontSize: 12,color: notification_title_color),),
                      ],
                    ),
                  ),
                ),
                CommonMethods().thickHorizontalLine(context),
                Container(
                  width: getWidth(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0,20,30,20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Payment method",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                        SizedBox(height: 8,),
                        Text("Cash on delivery",style: TextStyle(fontSize: 12,color: notification_title_color),),
                      ],
                    ),
                  ),
                ),
                CommonMethods().thickHorizontalLine(context),
              ],
            ),

          ),
        ),
      ),
    );
  }
  Widget billUI(String title,String price)
  {
   return Padding(
     padding: const EdgeInsets.only(top:15.0),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //child: Text("Name of dish"),
            width: getWidth(context)/2-50,
          ),
          Container(
            //color: button_color,
              width: 90,
              child: Text(title,style: TextStyle(fontSize: 12,color: notification_title_color),)),
          Container(
            //color: Colors.blue,
            width: 50,
            child: Text(price,style: TextStyle(fontSize: 12,color: notification_title_color)),
          )
        ],
      ),
   );
  }
}
