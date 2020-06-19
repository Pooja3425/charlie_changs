import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            height: getHeight(context)-108,
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
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (v){
                                    FocusScope.of(context).requestFocus(focusAddressLine1);
                                  },
                                  style: TextStyle(
                                      color: text_color,
                                      fontWeight: FontWeight.w400,fontSize: 12.5),
                                  decoration: InputDecoration(
                                      hintText: "Name of the address like home...",
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
                                  textInputAction: TextInputAction.next,
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
                                  textInputAction: TextInputAction.next,
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
                                  textInputAction: TextInputAction.next,
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
                                  textInputAction: TextInputAction.next,
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
                Container(
                  width: getWidth(context),
                  height: 73,
                  color: button_color,
                  child: Center(
                    child: Text("Save Address",style: TextStyle(color: Colors.white),),
                  ),
                )
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
}
