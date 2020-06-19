import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: switch_bg,
      width: getWidth(context),
      height: getHeight(context),
      child: Stack(
        children: <Widget>[
          Container(
            color: button_color,
            width: getWidth(context),
            height: getHeight(context)/2-30,
            alignment: Alignment.center,
            /* child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("THANKS!",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                      Text("We have received your order",style: TextStyle(fontSize: 15,color: Colors.white),),
                    ],
                  ),*/
          ),
          Positioned(
              top: getHeight(context)/2-228,
              //left: getWidth(context)/2,
              child: Container(
                width: getWidth(context),
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
}
