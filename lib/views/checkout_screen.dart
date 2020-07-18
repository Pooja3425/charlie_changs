import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/add_order_bloc.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/models/add_order_response_model.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/order_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://flutter.io';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();


class PayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => new CheckoutScreen(),
          '/widget': (_) {
            return SafeArea(
              child: WebviewScaffold(

                url: selectedUrl,
                javascriptChannels: jsChannels,
                mediaPlaybackRequiresUserGesture: false,
                appBar: AppBar(
                  title: const Text('Widget WebView'),
                ),
                withZoom: false,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  height: getHeight(context),
                  color: Colors.white,
                  child: const Center(
                    child: Text('Waiting.....'),
                  ),
                ),

              ),
            );
          },
        },
      ),
    );
  }
}
class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int itemTotal=0;
  List<Menu> orderModelList= new List();
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  @override
  void initState() {

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.contains(
            'http://www.example.com/redirect')) {
          Uri uri = Uri.parse(url);
//Take the payment_id parameter of the url.
          String paymentRequestId = uri.queryParameters['payment_id'];
//calling this method to check payment status
          _checkPaymentStatus(paymentRequestId);
        }
        else{
          print("ELSE");
        }
      }
    });
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
                      child: RichText(text: TextSpan(text:"This order is for home delivery (",style: TextStyle(color: notification_title_color),children: <TextSpan>[TextSpan(text: "Change",style: TextStyle(color: button_color),children: <TextSpan>[TextSpan(text: ")",style: TextStyle(color: notification_title_color),),]),]))/*Text("This order is for home delivery (",style: TextStyle(fontSize: 13,color: hint_text_color),),*/
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
                StreamBuilder(
                  stream: bloc.listStream,
                  builder: (context,snapshot){
                    orderModelList = snapshot.data;
                    return  ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orderModelList.length  ,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          int price = int.parse(orderModelList[index].price)*orderModelList[index].count;
                          itemTotal = itemTotal+int.parse(orderModelList[index].price)*orderModelList[index].count;
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
                                      child: Text("Rs ${price}",style: TextStyle(fontSize: 12,color: notification_title_color)),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 30.0),
                  child: Column(
                    children: <Widget>[
                      CommonMethods.horizontalLine(context),
                      SizedBox(height: 10,),
                      billUI("Item Total","Rs $itemTotal"),
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
                            /*Text("Redeem CC Points",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),*/
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Icon(Icons.arrow_drop_down,color: Colors.white,),
                                value: dropdownValueReedem,
                                elevation: 16,
                                style: TextStyle(
                                    color:  icon_color
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValueReedem = newValue;
                                  });
                                },
                                items: <String>['Redeem CC Points']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,style: TextStyle(color: notification_title_color,fontWeight: FontWeight.bold),),
                                  );
                                })
                                    .toList(),
                              ),
                            ),
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
                              Text("300",style: TextStyle(color: icon_color,fontSize: 12),),
                              Text("redeem",style: TextStyle(color: button_color,fontSize: 12,fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
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
                            Text("Delivered to HOME",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: notification_title_color),),
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
  String dropdownValueReedem = 'Redeem CC Points';
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
                              payment_mode = dropdownValue =="Cash on delivery"?"0":"1";
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
            InkWell(
                onTap: ()=>{
                  if(payment_mode =="0")
                   {
                     callPlaceOrderAPI()
                   }
                  else
                    {
                    createRequest()
                     // Navigator.push(context,MaterialPageRoute(builder: (context) => PayScreen() ),)
                    }

                },
                child: Text("Place Order",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600 ),)),
          ],
        ),
      ),
    );
  }

  AddOrderBloc mAddOrderBloc;
  AddOrderResponse mAddOrderResponse;
  String payment_mode="0";
  callPlaceOrderAPI() async{
    var resBody = {};
    var items = [];
    for(int i=0;i<orderModelList.length;i++)
      {
        if(orderModelList[i].count>1)
          {
            for(int j=0;j<orderModelList[i].count;j++)
              {
                resBody["hash"]=orderModelList[i].hash;
                resBody["name"]=orderModelList[i].name;
                items.add(resBody);
              }
          }
        else
          {
            resBody["hash"]=orderModelList[i].hash;
            resBody["name"]=orderModelList[i].name;
            items.add(resBody);
          }
      }


    String orderItems = json.encode(items);
    print("SSS ${json.decode(orderItems)}");

    SharedPreferences preferences = await SharedPreferences.getInstance();
        final body = jsonEncode({"del_area":preferences.getString(ADDRESS_HASH),
          "deliver_pickup":preferences.getString(DELIVERY_PICKUP),
          "coupon_code":"",
          "payment_mode":payment_mode,
          "reward_id_selected":"",
          "notes":"",
          "items":json.decode(orderItems)});


        String data = body;
    print("REQUETS ${data.replaceAll("\\", "").replaceAll('"', "")}");
    mAddOrderBloc=AddOrderBloc(data);
    mAddOrderBloc.dataStream.listen((onData){
      mAddOrderResponse = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mAddOrderResponse.msg);
        navigationPage();
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);

        CommonMethods.showShortToast(onData.message);

      }
    });
  }

  navigationPage() {
    Navigator.of(context).pushReplacementNamed('/BottomScreen');
  }

  final flutterWebviewPlugin = new FlutterWebviewPlugin();


  Future createRequest() async {

    Map<String, String> body = {
      "amount": "10", //amount to be paid
      "purpose": "Advertising",
      "buyer_name": "Pooja",
      "email": "poojajadhav130@gmail.com",
      "phone": "8208282138",
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "http://www.example.com/redirect/"
      //Where to redirect after a successful payment.
      //"webhook": "http://www.example.com/webhook/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.encodeFull("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_8338f3d1e94dd539eecfec357cb",
          "X-Auth-Token": "test_86f3567ae710bfb0eba0dbad138"
        },
        body: body);
    print("DDD${json.decode(resp.body)['success']}");
    print("ssssDDD${resp.body.toString()}");
    var data = json.decode(resp.body);
    var rest = data["payment_request"];

    // PaymentRequest pay =  rest.map<PaymentRequest>((json) => PaymentRequest.fromJson(json));
    print("OOO${rest['longurl']}");
    //print("ssssDDD${json.decode(resp.body)["payment_request"['longurl']]}");
    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      String longURL = rest['longurl']+
          "?embed=form";
      String selectedUrl = longURL;
      flutterWebviewPlugin.close();
      print("$selectedUrl");
//Let's open the url in webview.
      flutterWebviewPlugin.launch(selectedUrl,
      userAgent: kAndroidUserAgent);
    }
    else
    {
      CommonMethods.showLongToast(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        Uri.encodeFull("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_8338f3d1e94dd539eecfec357cb",
          "X-Auth-Token": "test_86f3567ae710bfb0eba0dbad138"
        });
    var realResponse = json.decode(response.body);
    print("SUCC $realResponse");
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
//payment is successful.
        flutterWebviewPlugin.close();
        callPlaceOrderAPI();
      } else {
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }
}
