import 'package:charliechang/blocs/delivery_loactions_bloc.dart';
import 'package:charliechang/models/delivery_locations_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bottom_screen.dart';

class PickupAddressScreen extends StatefulWidget {
  String from;
  PickupAddressScreen({this.from});
  @override
  _PickupAddressScreenState createState() => _PickupAddressScreenState();
}

class _PickupAddressScreenState extends State<PickupAddressScreen> {

  List<Pickup> mDeliveryLocationsList = new List();
  @override
  void initState() {
    callDeliveryLocationsAPI();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              flexibleSpace: appBar(context, "Select Outlet for Pickup"),
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 10,
                  width: getWidth(context),
                  color: switch_bg,
                ),
                Container(
                  width: getWidth(context),
                  height: getHeight(context)-122,
                  padding: EdgeInsets.only(top:15),
                  child: mDeliveryLocationsList.length>0?ListView.builder(
                    shrinkWrap: true,
                    itemCount: mDeliveryLocationsList.length,
                    itemBuilder: (context,index)
                    {
                      return addressRouUI(index);
                    },

                  ):Center(
                   child: Text("No nearby pickup location"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addressRouUI(int i) {
    var add1="House Number 844, After Gauri Petrol Pump, Porvorim, Goa 403051";
    var add2="Model's Millennium Vistas, Shop 1, Caranzalem, Goa - 403002 (Opp. Harley Davidson's Showroom)";

    return InkWell(
      onTap: (){
        if(widget.from == "checkout")
          {
            CommonMethods.setPreference(context, PICKUP_ADDRESS_NAME, mDeliveryLocationsList[i].name);
            CommonMethods.setPreference(context, PICKUP_ADDRESS_HASH, mDeliveryLocationsList[i].hash.toString());
            CommonMethods.setPreference(context, PICKUP_ADDRESS, mDeliveryLocationsList[i].address);
            CommonMethods.setPreference(context, DELIVERY_PICKUP, "2");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));
          }
        else
          {
            CommonMethods.setPreference(context, PICKUP_ADDRESS_NAME, mDeliveryLocationsList[i].name);
            CommonMethods.setPreference(context, PICKUP_ADDRESS_HASH, mDeliveryLocationsList[i].hash.toString());
            CommonMethods.setPreference(context, PICKUP_ADDRESS, mDeliveryLocationsList[i].address);
            CommonMethods.setPreference(context, DELIVERY_PICKUP, "2");

            print("ickup hash ${mDeliveryLocationsList[i].hash}");
            navigationPage();
            //Navigator.pop(context);
          }

      },

      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 10,),
            Text(mDeliveryLocationsList[i].name+ " Outlet",style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),

            Text(mDeliveryLocationsList[i].address,style: TextStyle(fontSize: 12,color: notification_title_color),),
            SizedBox(height: 10,),
            InkWell(
                onTap: () async {
                  /*final availableMaps = await MapLauncher.installedMaps;
                  await availableMaps.first.showMarker(
                    coords: Coords(double.parse(mDeliveryLocationsList[i].lattitude), double.parse(mDeliveryLocationsList[i].longitude)),
                    title: "${mDeliveryLocationsList[i].name}",
                  );*/
                   //final String googleMapsUrl = "comgooglemaps://?center=${mDeliveryLocationsList[i].lattitude},${mDeliveryLocationsList[i].longitude}";
                   final String googleMapsUrl = "comgooglemaps://?center=${mDeliveryLocationsList[i].lattitude},${mDeliveryLocationsList[i].longitude}";
                  final String appleMapsUrl = "https://maps.apple.com/?q=${mDeliveryLocationsList[i].lattitude},${mDeliveryLocationsList[i].longitude}";

                  if (await canLaunch(googleMapsUrl)) {
                    await launch(googleMapsUrl);
                  }
                  if (await canLaunch(appleMapsUrl)) {
                    await launch(appleMapsUrl, forceSafariVC: false);
                  } else {
                    throw "Couldn't launch URL";
                  }
                },
                child: Text("Find us on map",style: TextStyle(fontSize: 12,color: fab_color,fontWeight: FontWeight.w600),)),
            SizedBox(height: 15,),
            Container(width: getWidth(context),
              height: 0.5,
              color: icon_color,),
            SizedBox(height: 10,),
          ],
        ),
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
        CommonMethods.showLoaderDialog(context, "Loading");
      }
      else if(onData.status == Status.COMPLETED)
      {
        CommonMethods.dismissDialog(context);
        setState(() {
          mDeliveryLocationsList = mDeliveryLocationsResponse.pickup;
        });
        /*setState(() {
          for(int i=0;i<mDeliveryLocationsResponse.delivery.length;i++)
            {
              if(mDeliveryLocationsResponse.delivery[i].name =="Porvorim" || mDeliveryLocationsResponse.delivery[i].name =="Caranzalem")
                {
                  mDeliveryLocationsList.add(mDeliveryLocationsResponse.delivery[i]);
                }
            }
          print("SIZEE ${mDeliveryLocationsList.length}");
         // mDeliveryLocationsList = mDeliveryLocationsResponse.delivery;
        });*/
        //CommonMethods.showShortToast(mDeliveryLocationsResponse.);

      }
      else if(onData.status == Status.ERROR)
      {
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
  Widget appBar(BuildContext context,String title)
  {
    return Container(
      color: Colors.white,
      height: 80,
      width: getWidth(context),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right:30.0,left: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: (){
                  if(widget.from==null)
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
                    }
                  else
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));

                    }
                },
                child: Icon(Icons.keyboard_backspace,color: icon_color,)),
            SizedBox(width: 10,),
            Text(title,style: TextStyle(color: text_color,fontSize: 15,fontFamily: "Manrope",fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }

  Future<bool> goBack() {
    if(widget.from==null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
    }
    else
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));

    }
  }
}
