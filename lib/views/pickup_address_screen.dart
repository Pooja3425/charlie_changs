import 'package:charliechang/blocs/delivery_loactions_bloc.dart';
import 'package:charliechang/models/delivery_locations_response_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:flutter/material.dart';

import 'bottom_screen.dart';

class PickupAddressScreen extends StatefulWidget {
  @override
  _PickupAddressScreenState createState() => _PickupAddressScreenState();
}

class _PickupAddressScreenState extends State<PickupAddressScreen> {

  List<Delivery> mDeliveryLocationsList = new List();
  @override
  void initState() {
    callDeliveryLocationsAPI();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            flexibleSpace: CommonMethods.appBar(context, "Select Outlet for Pickup"),
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
    );
  }

  Widget addressRouUI(int i) {
    var add1="House Number 844, After Gauri Petrol Pump, Porvorim, Goa 403051";
    var add2="Model's Millennium Vistas, Shop 1, Caranzalem, Goa - 403002 (Opp. Harley Davidson's Showroom)";

    return InkWell(
      onTap: (){
        CommonMethods.setPreference(context, PICKUP_ADDRESS_NAME, mDeliveryLocationsList[i].name);
        CommonMethods.setPreference(context, ADDRESS_HASH, mDeliveryLocationsList[i].hash.toString());
        navigationPage();
      },

      child: Padding(
        padding: const EdgeInsets.only(left:30.0,right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 10,),
            Text(mDeliveryLocationsList[i].name+ " Outlet",style: TextStyle(fontSize: 15,color: notification_title_color,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),

            Text(i==0?add2:add1,style: TextStyle(fontSize: 12,color: notification_title_color),),
            SizedBox(height: 10,),
            Text("Find us on map",style: TextStyle(fontSize: 12,color: fab_color,fontWeight: FontWeight.w600),),
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
          for(int i=0;i<mDeliveryLocationsResponse.delivery.length;i++)
            {
              if(mDeliveryLocationsResponse.delivery[i].name =="Porvorim" || mDeliveryLocationsResponse.delivery[i].name =="Caranzalem")
                {
                  mDeliveryLocationsList.add(mDeliveryLocationsResponse.delivery[i]);
                }
            }
          print("SIZEE ${mDeliveryLocationsList.length}");
         // mDeliveryLocationsList = mDeliveryLocationsResponse.delivery;
        });
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
}
