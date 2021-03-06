import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:charliechang/views/pickup_checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  VoidCallback callback1;
  Function(String) func1;
  CartScreen({this.callback1, this.func1});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  List<Menu> foodItems;
  @override
  void initState() {
    foodItems=new List();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

    return SafeArea(
      child: Container(
        color: switch_bg,
        width: getWidth(context),
        //height: getHeight(context),
        child: Column(
          children: <Widget>[
           // appBar(context, "Cart"),
            StreamBuilder(
              stream: bloc.listStream,
              builder: (context,snapshot){
                //foodItems = snapshot.data;
                print("CART ${snapshot.hasData}");
                if (snapshot.hasData) {
                  foodItems = snapshot.data;
                  return foodItems.length>0?cartBody(foodItems):EmptyCart();
                }
                else
                  {
                    return Container(
                      width: getWidth(context),
                      height: getHeight(context)-164,
                      child: Stack(
              children: <Widget>[
                Container(
                  color: button_color,
                  width: getWidth(context),
                  height: getHeight(context)/2-110,
                  alignment: Alignment.center,

                ),
                Positioned(
                      top: getHeight(context)/2-308,
                      //left: getWidth(context)/2,
                      child: Container(
                        width: getWidth(context),
                        height: getHeight(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("OOPS!",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                            Text("There is no item in your cart.\nLet's add something.",textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.white),),
                            SizedBox(height: 30,),
                            Image.asset("assets/images/thanks_img.png",width: 119,height: 138,),
                            SizedBox(height: 40,),

                            //Text("Call Us On",style: TextStyle(color: hint_text_color,fontSize: 12),),
                            //Text("+91-99999 99999",style: TextStyle(color: hint_text_color,fontSize: 15,fontWeight: FontWeight.bold),),
                            SizedBox(height: 40,),
                            RaisedButton(
                              disabledColor: button_color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.3))),
                              child: Text("Order Now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),color: button_color,)
                          ],
                        ),
                      ))
              ],
            ),
                    );
                  }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget EmptyCart()
  {
    return Container(
      width: getWidth(context),
      height: getHeight(context)-84,
      child: Stack(
        children: <Widget>[
          Container(
            color: button_color,
            width: getWidth(context),
            height: getHeight(context)/2,
            alignment: Alignment.center,

          ),
          Positioned(
              top: getHeight(context)/2-200,
              //left: getWidth(context)/2,
              child: Container(
                width: getWidth(context),
                height: getHeight(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("OOPS!",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                    Text("There is no item in your cart.\nLet's add something.",textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.white),),
                    SizedBox(height: 30,),
                    Image.asset("assets/images/thanks_img.png",width: 119,height: 138,),
                    SizedBox(height: 40,),

                    //Text("Call Us On",style: TextStyle(color: hint_text_color,fontSize: 12),),
                    //Text("+91-99999 99999",style: TextStyle(color: hint_text_color,fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(height: 40,),
                    RaisedButton(
                      onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomScreen()),),
                      disabledColor: button_color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.3))),
                      child: Text("Order Now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),color: button_color,)
                  ],
                ),
              ))
        ],
      ),
    );
  }
  bool showCheckout=false;
  Widget cartBody(List<Menu> foodItems) {

   /* return Container();*/

    return ListView.builder(
        //physics: NeverScrollableScrollPhysics(),
        itemCount: foodItems.length  ,
        shrinkWrap: true,
        itemBuilder: (context,index){
          int price = int.parse(foodItems[index].price)*foodItems[index].count;
          return Padding(
            padding: const EdgeInsets.only(left:30.0,right: 30.0),
            child: Container(
              width: getWidth(context),
              /*child: Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text("${foodItems[index].name}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                      width: getWidth(context)/2-70,
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: button_color,width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(3.3))),
                      child: Row(
                        children: <Widget>[

                          foodItems[index].count >0? IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                            if(foodItems[index].count!=1)
                            {
                              print("SIZEEE ${foodItems[index].count}");

                              setState(() {
                                foodItems[index].count--;
                              });
                              widget.callback1();
                              widget.func1('REMOVE');

                            }
                            else
                              {
                                removeFromList(foodItems[index]);
                                widget.callback1();
                                widget.func1('REMOVE');
                              }
                          }):Container(),
                          Text("${foodItems[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                          IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                            setState(() {
                              foodItems[index].count++;
                             // addToCart(foodItems[index]);

                              //bloc.addToCart(index);
                              widget.callback1();
                              widget.func1('ADD');

                              // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                            });
                          })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Text("Rs ${price}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                    )

                  ],
                ),
              ),*/
            ),
          );
        });
  }
  addToCart(Menu foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(Menu foodItem) {
    bloc.removeFromList(foodItem);
  }

  appBar(BuildContext context, String s) {
    return Container(
      color: Colors.white,
      height: 80,
      width: getWidth(context),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left:20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*InkWell(
                    onTap: ()=> Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomScreen()),
                    ),
                    child: Icon(Icons.keyboard_backspace,color: icon_color,)),*/
                SizedBox(width: 10,),
                Text(s,style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),),
              ],
            ),

           /* Row(
              children: <Widget>[
                InkWell(
                    onTap: ()=>{
                     navigate()

                    },
                    child: Text("Checkout")),
              ],
            )*/
          ],
        ),
      ),
    );
  }

  navigateToCheckout() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pickup_delivery = prefs.getString(DELIVERY_PICKUP);
    /*if(pickup_delivery=="1")
      {*/
        Navigator.push(context,MaterialPageRoute(builder: (context) => CheckoutScreen() ),);
     /* }
    else
      {
        Navigator.push(context,MaterialPageRoute(builder: (context) => PickupCheckoutScreen() ),);
      }*/

  }

  navigate() {
    if(foodItems.length>0)
    {
      navigateToCheckout();
    }
    else
    {
      CommonMethods.showLongToast("No item in cart");
    }
  }
}
