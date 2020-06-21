import 'package:charliechang/blocs/category_bloc.dart';
import 'package:charliechang/models/category_response_model.dart';
import 'package:charliechang/models/icon_menu_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:charliechang/views/pickup_address_screen.dart';
import 'package:charliechang/views/pickup_checkout_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/getflutter.dart';

import 'switch_ui.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dropdownValue = "Home";
  bool status = false;
  List<IconModel> mIconModelList = new List();
  List<String> mImageList = new List();
  List<String> mImageListSlider = new List();
  List<Data> mCategoryList = new List();

  @override
  void initState() {
    mIconModelList.add(new IconModel(
        image_name: "assets/images/cc_specials.png", title: "CC Specials"));
    mIconModelList.add(new IconModel(
        image_name: "assets/images/cc_specials.png", title: "Veg Soup"));
    mIconModelList.add(new IconModel(
        image_name: "assets/images/cc_specials.png", title: "NonVeg Soup"));
    mIconModelList.add(new IconModel(
        image_name: "assets/images/cc_specials.png", title: "NonVeg Starter"));
    mIconModelList.add(new IconModel(
        image_name: "assets/images/cc_specials.png", title: "CC Specials"));
    mIconModelList.add(new IconModel(
        image_name: "assets/images/cc_specials.png", title: "CC Specials"));

    mImageList.add("assets/images/dish1.png");
    mImageList.add("assets/images/dish2.png");
    mImageList.add("assets/images/dish3.png");
    mImageList.add("assets/images/dish4.png");
    mImageList.add("assets/images/dish5.png");
    mImageList.add("assets/images/image2.png");

    mImageListSlider.add("assets/images/image.png");
    mImageListSlider.add("assets/images/image2.png");

    getCategoriesAPI();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = (getHeight(context) - kToolbarHeight - 24) / 2;
    final double itemWidth = getWidth(context) / 2;
    final double grid_size = (itemWidth / itemHeight) - 100;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,
            flexibleSpace: Container(
              //height: 78,
              width: getWidth(context),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          status?"Pickup from":DELIVER_TO,
                          style: TextStyle(
                              fontSize: 12,
                              color: hint_text_color,
                              fontFamily: "Manrope",
                              fontWeight: FontWeight.w300),
                        ),
                        InkWell(
                          onTap: (){
                            if(status)
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PickupAddressScreen()));
                              }
                            else
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
                              }

                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  status?"Caranzalem": "Home",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: text_color,
                                      fontFamily: "Manrope",
                                      fontWeight: FontWeight.bold),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 35,
                      width: 100,
                      child: CustomSwitch(
                        activeColor: switch_bg,
                        activeText: "Pickup",
                        inactiveText: "Delivery",
                        inactiveColor: switch_bg,
                        activeTextColor: fab_color,
                        inactiveTextColor: fab_color,
                        value: status,
                        onChanged: (value) {
                          print("VALUE : $value");
                          setState(() {
                            status = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          physics: enableScroll?ScrollPhysics():NeverScrollableScrollPhysics(),
          child: Container(
            width: getWidth(context),
            child: Column(
              children: <Widget>[
                // SizedBox(height: 15,),
                Container(
                  width: getWidth(context),
                  height: 270,
                  child: GFCarousel(
                    autoPlay: true,
                    pagerSize: 8,
                    activeIndicator: Colors.white,
                    passiveIndicator: Colors.transparent.withOpacity(0.5),
                    viewportFraction: 1.0,
                    height: 270,
                    // aspectRatio: 10,
                    enlargeMainPage: false,
                    pagination: true,
                    items: mImageListSlider.map(
                      (url) {
                        return Container(
                          //margin: EdgeInsets.all(8.0),
                          child: ClipRRect(
                            //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: Image.asset(url,
                                fit: BoxFit.cover, width: getWidth(context)),
                          ),
                        );
                      },
                    ).toList(),
                    onPageChanged: (index) {
                      setState(() {
                        index;
                      });
                    },
                  ),
                ),
                // SizedBox(height: 20,),
                Container(
                  width: getWidth(context),
                  height: 15,
                  color: switch_bg,
                ),
                Container(
                  width: getWidth(context),
                  height: 120,
                  padding: EdgeInsets.only(left: 30),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mCategoryList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 20.0, 8.0, 0),
                          child: Container(
                            width: 50,
                            //height: 80,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: switch_bg,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3.3),
                                      )),
                                  child: Center(
                                    child: Image.network(
                                      mCategoryList[index].image,
                                      width: 20,
                                      height: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  mCategoryList[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: icon_color, fontSize: 10),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 2,
                        width: getWidth(context),
                        color: switch_bg,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 40,
                        width: getWidth(context),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: switch_bg,
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //Icon(Icons.search,color: icon_color,size: 18,),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.search,
                                  color: icon_color,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  width: getWidth(context) - 110,
                                  alignment: Alignment.centerLeft,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      decoration: InputDecoration(
                                          //contentPadding: EdgeInsets.only(top: 5),
                                          //prefixIcon: Icon(Icons.search,color: icon_color,size: 18,),
                                          hintText: "Search for dishes",
                                          // alignLabelWithHint: ,
                                          hintStyle: TextStyle(
                                              fontSize: 12, color: icon_color),
                                          //contentPadding: EdgeInsets.only(bottom: 3),
                                          border: InputBorder.none,
                                          counterText: ''),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 2,
                        width: getWidth(context),
                        color: switch_bg,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                        child: Text(
                          "CC Specials",
                          style: TextStyle(color: icon_color),
                        ),
                      ),
                      Container(
                          width: getWidth(context),
                          // height: getHeight(context)/2,
                          child: GridView.count(
                            physics: enableScroll?NeverScrollableScrollPhysics():ScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                            //controller: new ScrollController(keepScrollOffset: false),
                            shrinkWrap: true,
                            children: List.generate(mImageList.length, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Card(
                                      child: Image.asset(
                                        mImageList[index],
                                        fit: BoxFit.cover,
                                        width: getWidth(context),
                                        height: 130,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.3))),
                                      clipBehavior:
                                          Clip.antiAliasWithSaveLayer,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 10),
                                    child: Text(
                                      "Name of the dish line 1 \nName of the dish line 2",
                                      style: TextStyle(fontSize: 12,color: icon_color),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5,right: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Rs 599",
                                          style: TextStyle(
                                              color: icon_color,
                                              fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            _settingModalBottomSheet(context);
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                color: fab_color),
                                            child: Center(
                                                child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )),
                                          ),
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                  )
                                ],
                              );
                            }),
                          ) /*ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0,8.0,0,8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Name of the dish",style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 5,),
                                    Text("Rs 599",style: TextStyle(color: icon_color,fontSize: 12),),
                                  ],
                                ),
                                Container(
                                  width:80,
                                  height:30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                      color: fab_color
                                  ),
                                  child: Center(child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 12),)),
                                )
                              ],
                            ),
                          );
                        })*/
                          ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext bc){
          return Container(
            width: getWidth(context),
            height: 100,
            color: button_color,
            child: Padding(
              padding: const EdgeInsets.only(left:30.0,right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close,color: Colors.white,size: 20,)),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("2 items added | Rs 1,200",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                          Text(status?"This order is for pickup":"This order is for home delivery",style: TextStyle(fontSize: 12,color: Colors.white,),),
                        ],
                      ),

                    ],
                  ),
                  InkWell(

                      onTap: (){
                        if(status)
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PickupCheckoutScreen()));
                        }
                        else
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
                        }
                      },
                      child: Text("View Cart",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          );
        }
    );
  }

  bool enableScroll = true;
  ScrollController scrollController;
  _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double delta = 270.0; // o
    print(maxScroll-currentScroll);
    if ( maxScroll - currentScroll >= 540) { // whatever you determine here
      //.. load more
      setState(() {
        //enableScroll = true;
      });
      print("END");
    }
    else
    {
      setState(() {
        //enableScroll = false;
      });
    }
  }
  CategoryBloc mCategoryBloc;
  CategoryRespose mCategoryRespose;
  void getCategoriesAPI() {
    mCategoryBloc=CategoryBloc();
    mCategoryBloc.dataStream.listen((onData){
      mCategoryRespose = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.hideDialog();
        setState(() {
          mCategoryList = mCategoryRespose.data;
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


