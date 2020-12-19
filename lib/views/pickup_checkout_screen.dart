import 'package:charliechang/models/order_model.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class PickupCheckoutScreen extends StatefulWidget {
  @override
  _PickupCheckoutScreenState createState() => _PickupCheckoutScreenState();
}

class _PickupCheckoutScreenState extends State<PickupCheckoutScreen> {

  List<OrderModel> orderModelList= new List();

  @override
  void initState() {
    orderModelList.add(new OrderModel("Name of dish", 1, 895));
    orderModelList.add(new OrderModel("Name of dish", 1, 895));
    super.initState();
  }

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
                        Text("Checkout",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left:33.0,top: 5),
                        child: RichText(text: TextSpan(text:"This order is for pickup (",style: TextStyle(color: notification_title_color),children: <TextSpan>[TextSpan(text: "Change",style: TextStyle(color: button_color),children: <TextSpan>[TextSpan(text: ")",style: TextStyle(color: notification_title_color),),]),]))/*Text("This order is for home delivery (",style: TextStyle(fontSize: 13,color: hint_text_color),),*/
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomUI(),
        body: SingleChildScrollView(
          child: Container(
            width: getWidth(context),
            child: Column(
              children: <Widget>[
                CommonMethods().thickHorizontalLine(context),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderModelList.length  ,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      int count=1;
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
                                  child: Text("${orderModelList[index].name}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                                  width: getWidth(context)/2-70,
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: button_color,width: 0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))),
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                                        if(orderModelList[index].count!=1)
                                        {
                                          setState(() {
                                            orderModelList[index].count--;
                                          });
                                        }
                                      }),
                                      Text("${orderModelList[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                                      IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                                        setState(() {
                                          orderModelList[index].count++;
                                          // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                                        });
                                      })
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right:8.0),
                                  child: Text("Rs ${orderModelList[index].price}",style: TextStyle(fontSize: 12,color: notification_title_color)),
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
                        Row(
                          children: <Widget>[
                            Text("Apply Coupon Code ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                            Icon(Icons.keyboard_arrow_down,size: 18,color: notification_title_color,)
                          ],
                        ),
                        SizedBox(height: 8,),
                        Text("You can redeem maximum of 300 points (worth Rs 300)",style: TextStyle(fontSize: 12,color: notification_title_color),),
                        SizedBox(height: 8,),
                        Container(

                          width: getWidth(context)-100,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)),
                              border: Border.all(color: input_border_color,width: 0.3)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("CHARLIE10",style: TextStyle(color: icon_color,fontSize: 12,fontWeight: FontWeight.w600),),
                                Text("Apply",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,left:20),
                          child: Text("Rs 300 discount applied",style: TextStyle(color: hint_text_color,fontSize: 12),),
                        )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Pickup Outlet Address",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                            Text("change",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Text("A-302, Blooming Dales Apartment,  Near Jupiter \nHospital, Opposite De Ballio restaurant, Baner, Pune",style: TextStyle(fontSize: 12,color: notification_title_color),),
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

  String dropdownValue = 'Cash on delivery';
  Widget bottomUI() {
    return Container(
      height: 100,
      width: getWidth(context),
      color: button_color,
      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select payment option",style: TextStyle(color: Colors.white,fontSize: 12 ),),
                SizedBox(height: 7,),
                Container(
                  width: getWidth(context)/2,
                  height: 38,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:5.0,right: 5.0),
                    child:  Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: button_color,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                          value: dropdownValue,
                          elevation: 16,
                          style: TextStyle(
                              color:  icon_color
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Cash on delivery', 'Online Payment']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style: TextStyle(color: Colors.white),),
                            );
                          })
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text("Make Payment",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600 ),),
          ],
        ),
      ),
    );
  }
}
