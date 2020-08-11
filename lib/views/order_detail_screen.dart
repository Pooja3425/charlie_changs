import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/blocs/menu_bloc.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/order_history_respons.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:charliechang/views/thanks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  Data orderData;
  OrderDetailScreen({this.orderData});
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {

  int item_total=0;
  String discount;
  int tax=0,net_payable;
  @override
  void initState() {
    discount =widget.orderData.discount;
    for(int i=0;i<widget.orderData.orderItems.length;i++)
      {
        setState(() {
          item_total = item_total+int.parse(widget.orderData.orderItems[i].quantity)*int.parse(widget.orderData.orderItems[i].price);
          tax = tax+int.parse(widget.orderData.orderItems[i].tax);
          net_payable = item_total+tax+int.parse(widget.orderData.discount)+int.parse(widget.orderData.deliveryCharge);
        });

      }
    getMenuAPI();
    setDate();
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
                        Text("${widget.orderData.ordercode}",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:33.0,top: 5),
                      child: Text("$date | $deliveryTime",style: TextStyle(fontSize: 13,color: hint_text_color),),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            addItemsTocart(widget.orderData);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => ThanksScreen()));
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
                    itemCount: widget.orderData.orderItems.length  ,
                    shrinkWrap: true,
                    itemBuilder: (context,index){

                      int price = int.parse(widget.orderData.orderItems[index].price)*int.parse(widget.orderData.orderItems[index].quantity);
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
                                child: Text("${widget.orderData.orderItems[index].itemName}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                              width: getWidth(context)/2-70,
                            ),
                            Text("X ${widget.orderData.orderItems[index].quantity}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                            Padding(
                              padding: const EdgeInsets.only(right:8.0),
                              child: Text("Rs ${price}",style: TextStyle(fontSize: 12,color: notification_title_color)),
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
                      billUI("Item Total","Rs ${item_total}"),
                      billUI("Discount","Rs ${widget.orderData.discount}"),
                      billUI("Taxes","Rs ${tax}"),
                      billUI("Delivery charge","Rs ${widget.orderData.deliveryCharge}"),
                      SizedBox(height: 20,),
                      CommonMethods.horizontalLine(context),
                      billUI("Net Payable","Rs ${net_payable}"),
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
                        Text("Delivered to ${widget.orderData.addressName.toUpperCase()}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
                        SizedBox(height: 8,),
                        Text("${widget.orderData.address1}"  "${widget.orderData.address2}",style: TextStyle(fontSize: 12,color: notification_title_color),),
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
                        Text(widget.orderData.isOnlinePaid=="0"?"Cash on delivery":"Online",style: TextStyle(fontSize: 12,color: notification_title_color),),
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

  var date,deliveryTime;
  void setDate() {
    var outputFormat = DateFormat("dd-MM-yyyy");
    var timeFormat = DateFormat("dd-MM-yyyy hh:mm aa");


    int year = int.parse(widget.orderData.deliveryDate.split("-")[0]);
    int mn = int.parse(widget.orderData.deliveryDate.split("-")[1]);
    int dt = int.parse(widget.orderData.deliveryDate.split("-")[2]);
    int hr = int.parse(widget.orderData.deliveryTime.split(":")[0]);
    int min = int.parse(widget.orderData.deliveryTime.split(":")[1]);

    var time = timeFormat.format(DateTime(year,mn,dt,hr,min));

    setState(() {
    date = outputFormat.format(DateTime(year,mn,dt));
      deliveryTime = time.split(" ")[1]+" "+time.split(" ")[2];
    });

  }

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  addItemsTocart(Data orders) {
    for(int i=0;i<orders.orderItems.length;i++)
    {
      for(int j=0;j<mMenuList.length;j++)
      {
        if(orders.orderItems[i].itemId == mMenuList[j].id)
        {
          print("QUATITY ${orders.orderItems[i].quantity}");
          for(int k=i;k<=int.parse(orders.orderItems[i].quantity);k++)
          {
            print("ITEM NAME ${mMenuList[j].name}");
            addToCart(mMenuList[j]);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutScreen(),));
          }
        }
      }
    }
  }

  addToCart(Menu foodItem) {
    bloc.addToList(foodItem);
  }

  MenuBloc mMenuBloc;
  MenuResponse mMenuResponse;
  List<Menu> mMenuList = new List();
  getMenuAPI() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String hashKey;
    if(preferences.getString(DELIVERY_PICKUP) =="1")
    {
      setState(() {
        hashKey = preferences.get(DELIVERY_ADDRESS_HASH);
      });
    }
    else
    {
      if(preferences.get(PICKUP_ADDRESS_NAME)!=null)
      {
        setState(() {
          hashKey = preferences.get(PICKUP_ADDRESS_HASH);
        });

      }

    }
    final body = jsonEncode({"hash":hashKey,"category":""});
    mMenuBloc=MenuBloc(body);
    mMenuBloc.dataStream.listen((onData){
      mMenuResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.hideDialog();
        setState(() {
          mMenuList = mMenuResponse.menu;


        });
        //CommonMethods.showShortToast(mDeliveryLocationsResponse.);
      }
      else if(onData.status == Status.ERROR)
      {
        // CommonMethods.hideDialog();
        CommonMethods.showShortToast(onData.message);
      }
    });
  }
}
