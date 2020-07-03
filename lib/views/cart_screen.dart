import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
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
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    List<Menu> foodItems;
    return SafeArea(
      child: Container(
        color: switch_bg,
        width: getWidth(context),
        height: getHeight(context),
        child: Column(
          children: <Widget>[

            CommonMethods.appBar(context, "Cart"),
            StreamBuilder(
              stream: bloc.listStream,
              builder: (context,snapshot){
                if (snapshot.data != null) {
                  foodItems = snapshot.data;
                  return cartBody(foodItems);
                }
                else
                  {
                    return Stack(
              children: <Widget>[
                Container(
                  color: button_color,
                  width: getWidth(context),
                  height: getHeight(context)/2-30,
                  alignment: Alignment.center,
                   child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("THANKS!",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                            Text("We have received your order",style: TextStyle(fontSize: 15,color: Colors.white),),
                          ],
                        ),
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
            );
                  }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget cartBody(List<Menu> foodItems) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: foodItems.length  ,
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
                          IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                            if(foodItems[index].count!=1)
                            {
                              setState(() {
                                foodItems[index].count--;
                              });
                            }
                          }),
                          Text("${foodItems[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                          IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                            setState(() {
                              foodItems[index].count++;
                              // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                            });
                          })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Text("Rs ${foodItems[index].price}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                    )

                  ],
                ),
              ),
            ),
          );
        });
  }
}
