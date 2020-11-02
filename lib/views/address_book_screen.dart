
import 'package:charliechang/blocs/customer_address_bloc.dart';
import 'package:charliechang/blocs/delivery_loactions_bloc.dart';
import 'package:charliechang/models/customer_address_response_model.dart';
import 'package:charliechang/models/delivery_locations_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/add_address_screen.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class AddressBookScreen extends StatefulWidget {
  String from;
  AddressBookScreen({this.from});
  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  Delivery dropdownValue;
  List<Delivery> mDeliveryLocationsList ;//= new List();
  List<Data> mCustomerAddressList ;//= new List();
  @override
  void initState() {
    mDeliveryLocationsList = new List();
    mCustomerAddressList = new List();
    callDeliveryLocationsAPI();
    callAddress();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: SafeArea(
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
                                onTap: (){
                                  if(widget.from==null)
                                    {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
                                    }
                                  else if(widget.from=="checkout")
                                  {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));
                                  }
                                  else if(widget.from =="otp" )
                                    {
                                      CommonMethods.showLongToast("Please select address to proceed ");
                                    }
                                  else if(widget.from =="complete")
                                  {
                                    CommonMethods.showLongToast("Please add address to proceed ");
                                  }
                                },
                                child: Icon(Icons.keyboard_backspace,color: icon_color,)),
                            SizedBox(width: 10,),
                            Text("Search Delivery Location",style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
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
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Delivery>(
                                      icon: Icon(Icons.arrow_drop_down,color: Colors.transparent,),
                                      value: dropdownValue,
                                      elevation: 16,
                                      style: TextStyle(
                                          color:  button_color,fontSize: 12
                                      ),
                                      hint: Text("Search Delivery Location",style: TextStyle(
                                          color:  input_border_color
                                      ),),
                                      onChanged: (Delivery newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddAddressScreen(delivery: dropdownValue,type: "a",mDeliveryList: mDeliveryLocationsList)),
                                          );
                                        });
                                      },
                                      items: mDeliveryLocationsList.map((Delivery map) {
                                        return new DropdownMenuItem<Delivery>(
                                          value: map,
                                          child: new Text(map.name,
                                              style: new TextStyle(color: Colors.black)),
                                        );
                                      }).toList(),
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
                        MaterialPageRoute(builder: (context) => AddAddressScreen(delivery: dropdownValue,type: "a",mDeliveryList: mDeliveryLocationsList)),
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
                  child: mCustomerAddressList.length >0?ListView.builder(
                    shrinkWrap: true,
                    itemCount: mCustomerAddressList.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.only(left:30.0,right: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                if(widget.from=="checkout")
                                {
                                  CommonMethods.setPreference(context, DELIVERY_ADDRESS_NAME, mCustomerAddressList[index].addressName);
                                  CommonMethods.setPreference(context, DELIVERY_ADDRESS_HASH, mCustomerAddressList[index].hash.toString());
                                  CommonMethods.setPreference(context, DELIVERY_PICKUP, "1");
                                  CommonMethods.setPreference(context, DELIVERY_ADDRESS, mCustomerAddressList[index].address1+" "+ mCustomerAddressList[index].address2);
                                  CommonMethods.setPreference(context, DELIVERY_ADDRESS_ID, mCustomerAddressList[index].id);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));
                                }
                                else
                                  {
                                    CommonMethods.setPreference(context, DELIVERY_ADDRESS_NAME, mCustomerAddressList[index].addressName);
                                    CommonMethods.setPreference(context, DELIVERY_ADDRESS_HASH, mCustomerAddressList[index].hash.toString());
                                    CommonMethods.setPreference(context, DELIVERY_PICKUP, "1");
                                    CommonMethods.setPreference(context, DELIVERY_ADDRESS_ID, mCustomerAddressList[index].id);
                                    CommonMethods.setPreference(context, DELIVERY_ADDRESS, mCustomerAddressList[index].address1+" "+ mCustomerAddressList[index].address2);
                                    navigationPage();
                                   // Navigator.pop(context);
                                  }

                                },
                              child: Container(
                                width: getWidth(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(mCustomerAddressList[index].addressName!=null?mCustomerAddressList[index].addressName:"",style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    Text(mCustomerAddressList[index].address1!=null&&mCustomerAddressList[index].address2!=null?mCustomerAddressList[index].address1+" "+mCustomerAddressList[index].address2:"",style: TextStyle(fontSize: 12,color: notification_title_color),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap:(){
                                /*if(dropdownValue==null)
                                  {
                                    CommonMethods.showLongToast("Select delivery location");
                                  }
                                else
                                  {*/
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddAddressScreen(delivery: dropdownValue,type: "e",data: mCustomerAddressList[index],mDeliveryList: mDeliveryLocationsList,)),
                                    );
                                //  }

                              },
                                child: Text("Edit",style: TextStyle(fontSize: 12,color: fab_color,fontWeight: FontWeight.w600),)),
                            SizedBox(height: 15,),
                            Container(width: getWidth(context),
                              height: 0.5,
                              color: icon_color,),
                            SizedBox(height: 10,),
                          ],
                        ),
                      );
                    },
                  ):Center(child: Text("No address added yet")),
                )
              ],
            ),
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

  DeliveryLocationsBloc mDeliveryLocationsBloc;
  DeliveryLocationsResponse mDeliveryLocationsResponse;
  void callDeliveryLocationsAPI() {
    mDeliveryLocationsBloc=DeliveryLocationsBloc();
    mDeliveryLocationsBloc.dataStream.listen((onData){
      mDeliveryLocationsResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.hideDialog();
        setState(() {
          mDeliveryLocationsList = mDeliveryLocationsResponse.delivery;
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

  CustomerAddressBloc mCustomerAddressBloc;
  CustomerAddressRespose mCustomerAddressRespose;

  callAddress()
  {
    mCustomerAddressBloc=CustomerAddressBloc();
    mCustomerAddressBloc.dataStream.listen((onData){
      mCustomerAddressRespose = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.hideDialog();
        CommonMethods.dismissDialog(context);
        setState(() {
          mCustomerAddressList = mCustomerAddressRespose.data;
        });
        //CommonMethods.showShortToast(mDeliveryLocationsResponse.);

      }
      else if(onData.status == Status.ERROR)
      {
        //CommonMethods.hideDialog();
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }
  void navigationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomScreen()),
    );
  }

  Future<bool> goBack() {
    if(widget.from==null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
    }
    else if(widget.from=="checkout")
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));
    }
    else if(widget.from =="otp" )
    {
      CommonMethods.showLongToast("Please select address to proceed ");
    }
    else if(widget.from =="complete")
    {
      CommonMethods.showLongToast("Please add address to proceed ");
    }
  }
}
