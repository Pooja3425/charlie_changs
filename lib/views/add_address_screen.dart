import 'dart:convert';
import 'dart:io';

import 'package:charliechang/blocs/add_delivery_address_bloc.dart';
import 'package:charliechang/blocs/update_address_bloc.dart';
import 'package:charliechang/models/add_delivery_address_response_model.dart';
import 'package:charliechang/models/customer_address_response_model.dart';
import 'package:charliechang/models/delivery_locations_response_model.dart';
import 'package:charliechang/models/update_address_resonse.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/bottom_screen.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  final Delivery delivery;
  String type;
  Data data;
  List<Delivery> mDeliveryList;
  AddAddressScreen({this.delivery,this.type,this.data,this.mDeliveryList});
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _controllerAddressName = TextEditingController();
  final _controllerAddressLine1 = TextEditingController();
  final _controllerAddressLine2 = TextEditingController();
  final _controllerLandmark = TextEditingController();
  final _controllerLocation = TextEditingController();
  final _controllerPincode = TextEditingController();
  final _controllerInstruction = TextEditingController();
  final _controllerCity = TextEditingController();
  final _controllerState = TextEditingController();
  final focusAddressLine1 = FocusNode();
  final focusAddressLine2 = FocusNode();
  final focusAddressLandmark = FocusNode();
  final focusAddressPincode = FocusNode();
  final focusAddressLocation = FocusNode();
  final focusAddressInstruction = FocusNode();
  final focusAddressCity = FocusNode();
  final focusAddressState = FocusNode();


  @override
  void initState() {

    _controllerState.text ="Goa";
    _controllerCity.text ="Goa";
    if(widget.type=="e")
      {
        _controllerAddressLine1.text=widget.data.address1;
        _controllerAddressLine2.text=widget.data.address2;
        _controllerPincode.text=widget.data.pincode;
        _controllerAddressName.text=widget.data.addressName;
        _controllerLandmark.text = widget.data.landmark;
        _controllerInstruction.text = widget.data.note;
        for(int i=0;i<widget.mDeliveryList.length;i++)
          {
            if(widget.data.areaid == widget.mDeliveryList[i].areaid)
              {
                dropdownValue = widget.mDeliveryList[i];
              }
          }


      }
    else
      {

      }
    if(widget.delivery !=null)
      {
        dropdownValue = widget.delivery;
        _controllerLocation.text = widget.delivery.name;
      }

    super.initState();
  }

  Delivery dropdownValue;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: bottomView(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            elevation: 0.0,
            flexibleSpace: CommonMethods.appBar(context, "Add New Address"),
          ),
        ),
        //resizeToAvoidBottomInset: true,
        //resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            width: getWidth(context),
           // height: getHeight(context)-108,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //CommonMethods.appBar(context, "Add New Address"),
                    Container(height: 10,color: switch_bg,
                      width: getWidth(context),),
                    Container(
                      width: getWidth(context),
                      //height: getHeight(context)-73,
                      child: Padding(
                        padding: const EdgeInsets.only(left:30.0,right: 30.0,top: 40),
                        child: Column(
                          children: <Widget>[

                            Container(
                              width: getWidth(context),
                              height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(color: input_border_color,width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(3.3))
                              ),
                              child: Padding(
                                padding: CommonMethods.textFieldPadding,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  maxLength: 10,
                                  controller: _controllerAddressName,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: Platform.isAndroid? TextInputAction.next:TextInputAction.done,
                                  onSubmitted: (v){
                                    FocusScope.of(context).requestFocus(focusAddressLine1);
                                  },
                                  style: TextStyle(
                                      color: text_color,
                                      fontWeight: FontWeight.w400,fontSize: 12.5),
                                  decoration: InputDecoration(
                                      hintText: 'Name your address e.g: “Home”, Office”..',
                                      hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                      contentPadding: EdgeInsets.only(bottom: 12),
                                      border: InputBorder.none,
                                      counterText: ''),
                                ),
                              ),
                            ),
                            sizeBox(),
                            Container(
                              width: getWidth(context),
                              height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(color: input_border_color,width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(3.3))
                              ),
                              child: Padding(
                                padding: CommonMethods.textFieldPadding,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  focusNode: focusAddressLine1,
                                  controller: _controllerAddressLine1,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: Platform.isAndroid? TextInputAction.next:TextInputAction.done,
                                  onSubmitted: (v){
                                    FocusScope.of(context).requestFocus(focusAddressLine2);
                                  },
                                  style: TextStyle(
                                      color: text_color,
                                      fontWeight: FontWeight.w400,fontSize: 12.5),
                                  decoration: InputDecoration(
                                      hintText: "Address line 1",
                                      hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                      contentPadding: EdgeInsets.only(bottom: 12),
                                      border: InputBorder.none,
                                      counterText: ''),
                                ),
                              ),
                            ),
                            sizeBox(),
                            Container(
                              width: getWidth(context),
                              height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(color: input_border_color,width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(3.3))
                              ),
                              child: Padding(
                                padding: CommonMethods.textFieldPadding,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  focusNode: focusAddressLine2,
                                  controller: _controllerAddressLine2,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: Platform.isAndroid? TextInputAction.next:TextInputAction.done,
                                  onSubmitted: (v){
                                    FocusScope.of(context).requestFocus(focusAddressLandmark);
                                  },
                                  style: TextStyle(
                                      color: text_color,
                                      fontWeight: FontWeight.w400,fontSize: 12.5),
                                  decoration: InputDecoration(
                                      hintText: "Address line 2",
                                      hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                      contentPadding: EdgeInsets.only(bottom: 12),
                                      border: InputBorder.none,
                                      counterText: ''),
                                ),
                              ),
                            ),
                            sizeBox(),
                            Container(
                              width: getWidth(context),
                              height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(color: input_border_color,width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(3.3))
                              ),
                              child: Padding(
                                padding: CommonMethods.textFieldPadding,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  maxLength: 100,
                                  focusNode: focusAddressLandmark,
                                  controller: _controllerLandmark,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: Platform.isAndroid? TextInputAction.next:TextInputAction.done,
                                  onSubmitted: (v){
                                    FocusScope.of(context).requestFocus(focusAddressLocation);
                                  },
                                  style: TextStyle(
                                      color: text_color,
                                      fontWeight: FontWeight.w400,fontSize: 12.5),
                                  decoration: InputDecoration(
                                      hintText: "Landmark",
                                      hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                      contentPadding: EdgeInsets.only(bottom: 12),
                                      border: InputBorder.none,
                                      counterText: ''),
                                ),
                              ),
                            ),

                            sizeBox(),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: getWidth(context)/2-15,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: input_border_color,width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                                  ),
                                  child: /*Padding(
                                    padding: CommonMethods.textFieldPadding,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      maxLength: 15,
                                      focusNode: focusAddressLocation,
                                      controller: _controllerLocation,
                                      textCapitalization: TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusAddressPincode);
                                      },
                                      style: TextStyle(
                                          color: text_color,
                                          fontWeight: FontWeight.w400,fontSize: 12.5),
                                      decoration: InputDecoration(
                                          hintText: "Location",
                                          hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                          contentPadding: EdgeInsets.only(bottom: 12),
                                          border: InputBorder.none,
                                          counterText: ''),
                                    ),
                                  )*/Padding(
                                    padding: CommonMethods.textFieldPadding,
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
                                          });
                                        },
                                        items: widget.mDeliveryList.map((Delivery map) {
                                          return new DropdownMenuItem<Delivery>(
                                            value: map,
                                            child: new Text(map.name,
                                                style: new TextStyle(color: Colors.black)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Container(
                                  width: getWidth(context)/2-65,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: input_border_color,width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                                  ),
                                  child: Padding(
                                    padding: CommonMethods.textFieldPadding,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      focusNode: focusAddressPincode,
                                      maxLength: 15,
                                      textCapitalization: TextCapitalization.words,
                                      controller: _controllerPincode,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusAddressInstruction);
                                      },
                                      style: TextStyle(
                                          color: text_color,
                                          fontWeight: FontWeight.w400,fontSize: 12.5),
                                      decoration: InputDecoration(
                                          hintText: "Pin code",
                                          hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                          contentPadding: EdgeInsets.only(bottom: 12),
                                          border: InputBorder.none,
                                          counterText: ''),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            sizeBox(),
                            Container(
                              width: getWidth(context),
                              //height: 38,
                              decoration: BoxDecoration(
                                  border: Border.all(color: input_border_color,width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(3.3))
                              ),
                              child: Padding(
                                padding: CommonMethods.textFieldPadding,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                 // maxLength: 150,
                                  maxLines: 5,
                                  focusNode: focusAddressInstruction,
                                  controller: _controllerInstruction,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: Platform.isAndroid? TextInputAction.next:TextInputAction.done,
                                  onSubmitted: (v){
                                          FocusScope.of(context).requestFocus(focusAddressCity);
                                        },
                                  style: TextStyle(
                                      color: text_color,
                                      fontWeight: FontWeight.w400,fontSize: 12.5),
                                  decoration: InputDecoration(
                                      hintText: "Instruction for delivery",
                                      hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                      //contentPadding: EdgeInsets.only(bottom: 12),
                                      border: InputBorder.none,
                                      counterText: ''),
                                ),
                              ),
                            ),
                            sizeBox(),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: getWidth(context)/2-40,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: input_border_color,width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                                  ),
                                  child: Padding(
                                    padding: CommonMethods.textFieldPadding,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      maxLength: 15,
                                      focusNode: focusAddressCity,
                                      controller: _controllerCity,
                                      textCapitalization: TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusAddressState);
                                      },
                                      style: TextStyle(
                                          color: text_color,
                                          fontWeight: FontWeight.w400,fontSize: 12.5),
                                      decoration: InputDecoration(
                                          hintText: "City",
                                          hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                         // contentPadding: EdgeInsets.only(bottom: 12),
                                          border: InputBorder.none,
                                          counterText: ''),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Container(
                                  width: getWidth(context)/2-40,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: input_border_color,width: 1.0),
                                      borderRadius: BorderRadius.all(Radius.circular(3.3))
                                  ),
                                  child: Padding(
                                    padding: CommonMethods.textFieldPadding,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      focusNode: focusAddressState,
                                      maxLength: 15,
                                      textCapitalization: TextCapitalization.words,
                                      controller: _controllerState,
                                      textInputAction: TextInputAction.done,

                                      style: TextStyle(
                                          color: text_color,
                                          fontWeight: FontWeight.w400,fontSize: 12.5),
                                      decoration: InputDecoration(
                                          hintText: "State",
                                          hintStyle: TextStyle(color: hint_text_color,fontSize: 12.5),
                                         // contentPadding: EdgeInsets.only(bottom: 12),
                                          border: InputBorder.none,
                                          counterText: ''),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget sizeBox(){
    return SizedBox(height: 15,);
  }

  bool isValid() {
    if(_controllerAddressName.text.length==0)
      {
        CommonMethods.showShortToast("Please enter address name");
        return false;
      }
    if(_controllerAddressLine1.text.length==0)
    {
      CommonMethods.showShortToast("Please enter address line 1");
      return false;
    }
    if(_controllerAddressLine2.text.length==0)
    {
      CommonMethods.showShortToast("Please enter address line 2");
      return false;
    }
    if(dropdownValue==null)
    {
      CommonMethods.showShortToast("Please enter location");
      return false;
    }
    return true;
  }

  AddDeliveryAddressBloc mAddDeliveryAddressBloc;
  AddDeliveryAddressRespose mAddDeliveryAddressRespose;
  void callAPI() {
    final body = jsonEncode({
      "address_name":_controllerAddressName.text,
      "address1":_controllerAddressLine1.text,
      "address2":_controllerAddressLine2.text,
      "area_id": dropdownValue.areaid,
      "pincode":_controllerPincode.text,
      "landmark":_controllerLandmark.text,
      "note":_controllerInstruction.text,
      "is_default":"1",
    });
    mAddDeliveryAddressBloc=AddDeliveryAddressBloc(body);
    mAddDeliveryAddressBloc.dataStream.listen((onData){
      mAddDeliveryAddressRespose = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
       // CommonMethods.hideDialog();
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mAddDeliveryAddressRespose.msg);
        CommonMethods.setPreference(context, DELIVERY_ADDRESS_NAME, _controllerAddressName.text);
        //CommonMethods.setPreference(context, ADDRESS_HASH, mCustomerAddressList[index].hash.toString());
        navigationPage();
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
      MaterialPageRoute(builder: (context) => AddressBookScreen()),
    );
  }

  UpdateAddressBloc mUpdateAddressBloc;
  UpdateAddress mUpdateAddress;
  callUpdateAPI() {
    final body = jsonEncode({
      "address_name":_controllerAddressName.text,
      "address1":_controllerAddressLine1.text,
      "address2":_controllerAddressLine2.text,
      "area_id": dropdownValue.areaid,
      "id":widget.data.id,
      "pincode":_controllerPincode.text,
      "landmark":_controllerLandmark.text,
      "note":_controllerInstruction.text,
      "is_primary":""
    });
    mUpdateAddressBloc=UpdateAddressBloc(body);
    mUpdateAddressBloc.dataStream.listen((onData){
      mUpdateAddress = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
        // CommonMethods.hideDialog();
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(mUpdateAddress.msg);
        CommonMethods.setPreference(context, DELIVERY_ADDRESS_NAME, _controllerAddressName.text);
        //CommonMethods.setPreference(context, ADDRESS_HASH, mCustomerAddressList[index].hash.toString());
        navigationPage();
      }
      else if(onData.status == Status.ERROR)
      {
        //CommonMethods.hideDialog();
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }

  Widget bottomView() {
    return InkWell(
      onTap: (){
        if(isValid())
        {
          if(widget.type=="a")
          {
            callAPI();
          }
          else
          {
            callUpdateAPI();
          }

        }
      },
      child: Container(
        width: getWidth(context),
        height: 73,
        color: button_color,
        child: Center(
          child: Text("Save Address",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
