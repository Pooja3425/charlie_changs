import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart' as blocPattern;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:charliechang/blocs/cart_bloc.dart';
import 'package:charliechang/blocs/cartlistBloc.dart';
import 'package:charliechang/blocs/category_bloc.dart';
import 'package:charliechang/blocs/menu_bloc.dart';
import 'package:charliechang/blocs/slider_bloc.dart';
import 'package:charliechang/models/category_response_model.dart';
import 'package:charliechang/models/food_item_model.dart';
import 'package:charliechang/models/icon_menu_model.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/scroll_model.dart';
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:charliechang/views/address_book_screen.dart';
import 'package:charliechang/views/checkout_screen.dart';
import 'package:charliechang/views/demo.dart';
import 'package:charliechang/views/pickup_address_screen.dart';
import 'package:charliechang/views/pickup_checkout_screen.dart';
import 'package:charliechang/views/refer_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'switch_ui.dart';
import 'package:charliechang/models/slider_response.dart' as slider;
import 'package:flutter/material.dart' hide NestedScrollView;

class HomeScreen extends StatefulWidget {

  VoidCallback callback1;
  Function(String) func1;
  HomeScreen({this.callback1, this.func1});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  String dropdownValue = "Home";
  bool status;
  //List<IconModel> mIconModelList = new List();
  List<String> mImageList = new List();
  List<String> mImageListSlider = new List();
  List<Data> mCategoryList = new List();
  String hashKey,category;
  String deliveryAddressName="";
  String pickupAddressName="";
  final CartListBloc bloc = blocPattern.BlocProvider.getBloc<CartListBloc>();
  TextEditingController _searchController = TextEditingController();

  bool isMenuCalled=false;

  //internet
  bool _isInternetAvailable = true;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  final scrollDirection = Axis.vertical;

  String cat_name="";
  bool _IsSearching;
  String _searchText = "";
  ScrollController mainContoller;
  void onConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      setState(() {
        _isInternetAvailable = false;
      });
    } else {
      setState(() {
        _isInternetAvailable = true;
      });
    }
  }

  @override
  void dispose() {
    expandController.dispose();
   _subscription.cancel();
    super.dispose();
  }
  @override
  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection,
    );
    _connectivity = new Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(onConnectivityChange);
    // status=false;
    mImageListSlider.add("assets/images/image.png");
    mImageListSlider.add("assets/images/image.png");
    _IsSearching=false;
    sliderList.add(slider.Data(imagePath: ""));
  //  status= false;
    getDeliveryAddress();
    if(_isInternetAvailable)
      {
        getCategoriesAPI();
        callSliderApi();
      }
    else
      {
        CommonMethods.showLongToast(CHECK_INTERNET);
      }

    mainContoller = ScrollController();
    scrollController = ScrollController();
    prepareAnimations();
    _runExpandCheck();
    //controller.addListener(_scrollListener);

    super.initState();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  _HomeScreenState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchController.text;
          _buildSearchList();
        });
      }
    });
  }

  List<Menu> _searchList=new List();
  List<Menu> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList =
          mMenuList; //_list.map((contact) =>  Uiitem(contact)).toList();
    } else {
      _searchList = mMenuList
          .where((element) =>
      element.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      print('${_searchList.length}');
      return _searchList; //_searchList.map((contact) =>  Uiitem(contact)).toList();
    }
  }

  void checkScrollPosition(ScrollNotification scrollNotification) {
    double maxScroll = scrollNotification.metrics.maxScrollExtent;
    double minScroll = scrollNotification.metrics.minScrollExtent;
    double currentScroll = scrollNotification.metrics.pixels;
    double delta = 180.0; // or something else..
   // print("SSS  ${maxScroll - minScroll} ");
    var timerInfo = Provider.of<ScrollModel>(context, listen: false);
    timerInfo.setScroll(true);
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = (getHeight(context) - 70 - 24) / 2.10;
    final double itemWidth = getWidth(context) / 2;
    //print("grid aspect ${itemWidth/itemHeight}");
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    DateFormat dateFormat = new DateFormat.Hm();

    DateTime currentTime = DateTime.now();
    DateTime open = dateFormat.parse("10:30");
    open = new DateTime(currentTime.year, currentTime.month, currentTime.day, open.hour, open.minute);

    DateTime open1 = dateFormat.parse("19:00");
    open1 = new DateTime(currentTime.year, currentTime.month, currentTime.day, open1.hour, open1.minute);

    DateTime close = dateFormat.parse("14:30");
    close = new DateTime(currentTime.year, currentTime.month, currentTime.day, close.hour, close.minute);

    DateTime close1 = dateFormat.parse("22:30");
    close1 = new DateTime(currentTime.year, currentTime.month, currentTime.day, close1.hour, close1.minute);
    return SafeArea(
      child: Scaffold(
        floatingActionButton:Consumer<ScrollModel>(
          builder: (context, data, child) {
            return data.getValue()?FloatingActionButton(onPressed: (){
                controller.animateTo(0.0, curve: Curves.linear, duration: Duration (milliseconds: 500));
            },
              child: Icon(Icons.keyboard_arrow_up),
              backgroundColor: fab_color,):Container();
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,
            flexibleSpace: Container(
              width: getWidth(context),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: getWidth(context)/2+30,
                          child: Column(
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
                                      //1 = pickup  0=delivery
                                     // CommonMethods.setPreference(context, TOGGLE_VALUE, "1");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PickupAddressScreen()));
                                    }
                                  else
                                    {
                                     // CommonMethods.setPreference(context, TOGGLE_VALUE, "0");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
                                    }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          status?pickupAddressName: deliveryAddressName,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: text_color,
                                              fontFamily: "Manrope",
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                if(value==true)
                                {
                                  CommonMethods.setPreference(context, TOGGLE_VALUE, "1");
                                  CommonMethods.setPreferenceBool(context, TOGGLE_VALUE_BOOL, value);
                                  print("dataa T${bloc.getCartCount()}");
                                  if(bloc.getCartCount()==0)
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PickupAddressScreen()));
                                    }
                                  else
                                    {
                                      showWarningDialog("p");
                                    }
                                }
                                else
                                {
                                  CommonMethods.setPreference(context, TOGGLE_VALUE, "0");
                                  CommonMethods.setPreferenceBool(context, TOGGLE_VALUE_BOOL, value);
                                  print("dataa F ${bloc.getCartCount()}");
                                  if(bloc.getCartCount() == 0)
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
                                    }
                                  else
                                    {
                                      showWarningDialog("d");
                                    }
                                }

                                getDeliveryAddress();
                              });

                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    currentTime.isAfter(open) && currentTime.isBefore(close) || currentTime.isAfter(open1) && currentTime.isBefore(close1)?Container(
                      height: 25,
                      width: getWidth(context),
                      child:Marquee(
                        text: " OUTLET CLOSED NOW. | ORDER TIMINGS : 12:00 PM TO 02:30 PM AND 07:00 PM TO 10:30 PM",
                        style: TextStyle(fontWeight: FontWeight.bold,color: fab_color),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20.0,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      )
                    ):Container()
                  ],
                ),
              ),
            ),
          ),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification){
            if(scrollNotification is ScrollStartNotification)
            {
              // print("POOO ${scrollNotification.dragDetails.localPosition.dy}");
              checkScrollPosition(scrollNotification);
            }
            else if(scrollNotification is ScrollEndNotification)
            {
              checkScrollPosition(scrollNotification);
            }
            else if(scrollNotification is ScrollUpdateNotification)
            {
              checkScrollPosition(scrollNotification);
            }
            return true;
          },
          child: SingleChildScrollView(
            scrollDirection: scrollDirection,
            controller: controller,
            child: Container(
              width: getWidth(context),
              child: Column(
                children: <Widget>[
                  /*GFCarousel(
                    scrollDirection: Axis.horizontal,
                    autoPlay: true,
                    //autoPlayAnimationDuration: Duration(seconds: 1),
                    pagerSize: 8,
                    reverse: false,
                    pauseAutoPlayOnTouch: Duration(seconds: 5),
                    activeIndicator: Colors.white,
                    passiveIndicator: Colors.transparent.withOpacity(0.5),
                    viewportFraction: 1.0,
                    autoPlayInterval: Duration(seconds: 5),
                    enableInfiniteScroll: true,
                    height: 280,
                    // aspectRatio: 10,
                    enlargeMainPage: false,
                    pagination: true,
                    items: sliderList.map(
                          (url) {
                        return InkWell(
                          onTap: (){
                            if(url.title.contains("referral") || url.title.contains("refer") )
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReferScreen(),));
                            }
                          },
                          child: Container(
                            //margin: EdgeInsets.all(8.0),
                            child: ClipRRect(
                              //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Image.network(IMAGE_BASE_URL+url.imagePath,
                                  fit: BoxFit.cover, width: getWidth(context)),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onPageChanged: (index) {
                      setState(() {
                        index;
                      });
                    },
                  ),*/
                  SizedBox(
                      height: 280.0,
                      width: getWidth(context),
                      child: Carousel(
                        images: sliderList.map(
                              (url) {
                            return InkWell(
                              onTap: (){
                                if(url.title.contains("referral") || url.title.contains("refer") )
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReferScreen(),));
                                }
                              },
                              child: Container(
                                //margin: EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  child: Image.network(IMAGE_BASE_URL+url.imagePath,
                                      fit: BoxFit.cover, width: getWidth(context)),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.grey,
                        autoplayDuration: Duration(seconds: 5),
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.transparent,
                        borderRadius: true,
                      )
                  ),
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
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 20.0, 2.0, 0),
                            child: Container(
                              width: 62,
                              //height: 80,
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    category = mCategoryList[index].name;
                                    print("$category");
                                    _scrollToIndex(index);
                                  });

                                },
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
                                          IMAGE_BASE_URL+mCategoryList[index].image,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        mCategoryList[index].name,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          //letterSpacing: 0.5,
                                            //letterSpacing: 1,
                                            color: icon_color, fontSize: 9),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: 2,
                    width: getWidth(context),
                    color: switch_bg,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      height: 40,
                      width: getWidth(context),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: switch_bg,
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //Icon(Icons.search,color: icon_color,size: 18,),
                            SizedBox(
                              width: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:3.0),
                              child: Icon(
                                Icons.search,
                                color: icon_color,
                                size: 18,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Container(
                              width: getWidth(context) - 110,
                              //alignment: Alignment.centerLeft,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                controller: _searchController,
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
                            _IsSearching?InkWell(
                              onTap: ()=>_searchController.clear(),
                              child: Icon(
                                Icons.clear,
                                color: icon_color,
                                size: 18,
                              ),
                            ):Container(),
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
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        _IsSearching?  Container(
                            width: getWidth(context),
                            margin: EdgeInsets.only(top: 20),
                            // height: getHeight(context)/2,
                            child: _searchList.length>0?GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: (itemWidth / itemHeight),
                              //controller: new ScrollController(keepScrollOffset: false),
                              shrinkWrap: true,
                              children: buildSearchList(_searchList),
                            ):Center(child: Text("No such item found"),)

                        ): mMenuList.length>0?ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap:true,
                            itemCount: mCategoryList.length,
                            itemBuilder: (context,index){
                              return  _wrapScrollTag(
                                index: index,
                                child: StickyHeader(
                                    header:  Padding(
                                      padding: const EdgeInsets.only(top: 15.0, bottom: 1.0),
                                      child: Text(
                                        "${mCategoryList[index].name}",
                                        style: TextStyle(color: fab_color,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    content:  GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      //controller: new ScrollController(keepScrollOffset: false),
                                      shrinkWrap: true,
                                      children: buildList(mMenuList,mCategoryList[index].name),
                                    )


                                ),
                              );

                            }):Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Center(child: CircularProgressIndicator(),),
                            ),

                        /* Container(
                              width: getWidth(context),
                              margin: EdgeInsets.only(top: 20),
                              // height: getHeight(context)/2,
                              child: mMenuList.length>0?GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                childAspectRatio: (itemWidth / itemHeight),
                                //controller: new ScrollController(keepScrollOffset: false),
                                shrinkWrap: true,
                                children: _IsSearching?buildList(_searchList):buildList(mMenuList),
                              ):Center(child: CircularProgressIndicator(),)

                          ),*/

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
      ),
    );
  }
  AnimationController expandController;
  Animation<double> animation;

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.ease,
    );
  }

  void _runExpandCheck() {
    if(isStretched) {
      expandController.forward();
    }
    else {
      expandController.reverse();
    }
  }
  bool isStretched = false;
  List<Widget> buildSliverHeader() {
    final List<Widget> widgets = <Widget>[];

    widgets.add(
      SliverList(delegate: SliverChildListDelegate([
        sliderList.length>0?SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          /*child: GFCarousel(
            autoPlay: true,
            pagerSize: 8,
            activeIndicator: Colors.white,
            passiveIndicator: Colors.transparent.withOpacity(0.5),
            viewportFraction: 1.0,
            height: 270,
            // aspectRatio: 10,
            enlargeMainPage: false,
            pagination: true,
            items: sliderList.map(
                  (url) {
                return InkWell(
                  onTap: (){
                    if(url.title.contains("referral") || url.title.contains("refer") )
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReferScreen(),));
                      }
                  },
                  child: Container(
                    //margin: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Image.network(IMAGE_BASE_URL+url.imagePath,
                          fit: BoxFit.cover, width: getWidth(context)),
                    ),
                  ),
                );
              },
            ).toList(),
            onPageChanged: (index) {
              setState(() {
                index;
              });
            },
          ),*/
        ):Container()
      ]))
        /*SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          expandedHeight: 250.0,
          floating: false,
          pinned: false,
          stretch: isStretched,
          flexibleSpace: FlexibleSpaceBar(
            background:,
          ),
          *//**//*
        )*/);

    //widgets.add( );

    return widgets;
  }

  int counter = -1;
  Future _scrollToIndex(int index) async {
    print("Anchot");

    await controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    //controller.highlight(index);
  }

  addToCart(Menu foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(Menu foodItem) {
    bloc.removeFromList(foodItem);
  }

  Widget staggeredView(Menu menu)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Card(
            child: AspectRatio(
              aspectRatio: 7/6,
              child: Image.network(
                IMAGE_BASE_URL+menu.image,
                fit: BoxFit.cover,
                width: getWidth(context)/2-60,
                height: getWidth(context)/2-80,
              ),
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
          child: Container(
            height:40,
            child: Text(
              menu.name,
              maxLines: 2,
              style: TextStyle(fontSize: 12,color: icon_color),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 5,right: 5),
          child: Row(
            children: <Widget>[
              Text(
                "Rs "+menu.price,
                style: TextStyle(
                    color: icon_color,
                    fontSize: 12),
              ),
              menu.count ==0?InkWell(
                onTap: (){
                  //final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
                  addToCart(menu);
                  menu.count++;
                  //bloc.addToCart(index);
                  widget.callback1();
                  widget.func1('ADD');
                  setState(() {
                    //
                    // mMenuList[index].count ++;
                  });
                  // _settingModalBottomSheet(context);
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
              ):Container(
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(color: button_color,width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(3.3))),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                      /*if(mMenuList[index].count!=1)
                                                {*/
                      //bloc.removeFromList(mMenuList[index]);


                      widget.callback1();
                      widget.func1('REMOVE');
                      if(menu.count!=1)
                      {
                        setState(() {
                          menu.count--;
                        });
                      }
                      else
                      {
                        removeFromList(menu);
                      }



                      //}
                    }),
                    Text("${menu.count}",style: TextStyle(color: button_color,fontSize: 13),),
                    IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                      print("ADDDD");
                      setState(() {
                        menu.count++;
                        // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                      });
                      // addToCart(mMenuList[index]);
                      widget.callback1();
                      widget.func1('ADD');
                    })
                  ],
                ),
              ),
            ],
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
          ),
        )
      ],
    );
  }

  List<Widget> buildList(List<Menu> mMenuList,String cat)
  {
    List<Menu> mTempList =new List();
    for(int i=0;i<mMenuList.length;i++)
      {
         if(mMenuList[i].category == cat)
           {
             //print("CCC ${category}");
             mTempList.add(mMenuList[i]);
           }
      }
    DateFormat dateFormat = new DateFormat.Hm();

    DateTime currentTime = DateTime.now();
    DateTime open = dateFormat.parse("10:30");
    open = new DateTime(currentTime.year, currentTime.month, currentTime.day, open.hour, open.minute);

    DateTime open1 = dateFormat.parse("19:00");
    open1 = new DateTime(currentTime.year, currentTime.month, currentTime.day, open1.hour, open1.minute);

    DateTime close = dateFormat.parse("14:30");
    close = new DateTime(currentTime.year, currentTime.month, currentTime.day, close.hour, close.minute);

    DateTime close1 = dateFormat.parse("22:30");
    close1 = new DateTime(currentTime.year, currentTime.month, currentTime.day, close1.hour, close1.minute);
   /* if((currentTime.isAfter(open) && currentTime.isBefore(close)) || (currentTime.isAfter(open1) && currentTime.isBefore(close1))) {
      print("onn");
    }
    else{
      print("off");
    }*/
    return List.generate(/*mMenuList.length*/mTempList.length, (index) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: Card(
                  child: AspectRatio(
                    aspectRatio: 7/6,
                    child: Image.network(
                      IMAGE_BASE_URL+mTempList[index].image,
                      fit: BoxFit.cover,
                      width: getWidth(context)/2-60,
                      height: getWidth(context)/2-80,
                    ),
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
              child: Container(
                height:35,
                child: Text(
                  mTempList[index].name,
                  maxLines: 2,
                  style: TextStyle(fontSize: 12,color: icon_color),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5,right: 5),
              child: Row(
                children: <Widget>[
                  Text(
                    "Rs "+mTempList[index].price,
                    style: TextStyle(
                        color: icon_color,
                        fontSize: 12),
                  ),

                  /*currentTime.isAfter(open) && currentTime.isBefore(close) || currentTime.isAfter(open1) && currentTime.isBefore(close1)?*/  mTempList[index].count ==0?InkWell(
                    onTap: (){
                      //final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
                      addToCart(mTempList[index]);
                      mTempList[index].count++;
                      //bloc.addToCart(index);
                      widget.callback1();
                      widget.func1('ADD');
                      setState(() {});
                      // _settingModalBottomSheet(context);
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
                    )
                  ):Container(
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: button_color,width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(3.3))),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                          /*if(mMenuList[index].count!=1)
                                                  {*/
                          //bloc.removeFromList(mMenuList[index]);
                          print("SIZEEE ${mMenuList[index].count}");

                          widget.callback1();
                          widget.func1('REMOVE');
                          if(mTempList[index].count!=1)
                            {
                              setState(() {
                                mTempList[index].count--;
                              });
                            }
                          else
                            {
                              removeFromList(mTempList[index]);
                            }



                          //}
                        }),
                        Text("${mTempList[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                        IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                          print("ADDDD");
                          setState(() {
                            mTempList[index].count++;
                            // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                          });
                         // addToCart(mMenuList[index]);
                          widget.callback1();
                          widget.func1('ADD');
                        })
                      ],
                    ),
                  )/*:Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(3)),
                        color: Colors.grey),
                    child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12),
                        )),
                  ),*/
                ],
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ),
      );
    });
  }


  List<Widget> buildSearchList(List<Menu> mTempList)
  {
    DateFormat dateFormat = new DateFormat.Hm();

    DateTime currentTime = DateTime.now();
    DateTime open = dateFormat.parse("10:30");
    open = new DateTime(currentTime.year, currentTime.month, currentTime.day, open.hour, open.minute);

    DateTime open1 = dateFormat.parse("19:00");
    open1 = new DateTime(currentTime.year, currentTime.month, currentTime.day, open1.hour, open1.minute);

    DateTime close = dateFormat.parse("14:30");
    close = new DateTime(currentTime.year, currentTime.month, currentTime.day, close.hour, close.minute);

    DateTime close1 = dateFormat.parse("22:30");
    close1 = new DateTime(currentTime.year, currentTime.month, currentTime.day, close1.hour, close1.minute);

    return List.generate(/*mMenuList.length*/mTempList.length, (index) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Card(
                  child: AspectRatio(
                    aspectRatio: 7/6,
                    child: InkWell(
                      onTap: (){
                        /*if(isStretched)
                          {
                            setState(() {
                              isStretched = false;
                            });
                          }
                        else
                          {
                            setState(() {
                              isStretched = true;
                            });
                          }
                        _runExpandCheck();
                        print("vall $isStretched");*/
                      },
                      child: Image.network(
                        IMAGE_BASE_URL+mTempList[index].image,
                        fit: BoxFit.cover,
                        width: getWidth(context)/2-60,
                        height: getWidth(context)/2-80,
                      ),
                    ),
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
                child: Container(
                  height:40,
                  child: Text(
                    mTempList[index].name,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12,color: icon_color),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5,right: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Rs "+mTempList[index].price,
                      style: TextStyle(
                          color: icon_color,
                          fontSize: 12),
                    ),
                    currentTime.isAfter(open) && currentTime.isBefore(close) || currentTime.isAfter(open1) && currentTime.isBefore(close1)? mTempList[index].count ==0?InkWell(
                      onTap: (){
                        //final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
                        addToCart(mTempList[index]);

                        //bloc.addToCart(index);
                        widget.callback1();
                        widget.func1('ADD');
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
                      )
                    ):Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: button_color,width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(3.3))),
                      child: Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.remove,color: button_color,size: 15,), onPressed: (){
                            /*if(mMenuList[index].count!=1)
                                                    {*/
                            //bloc.removeFromList(mMenuList[index]);
                            print("SIZEEE ${mMenuList[index].count}");

                            widget.callback1();
                            widget.func1('REMOVE');
                            if(mTempList[index].count!=1)
                            {
                              setState(() {
                                mTempList[index].count--;
                              });
                            }
                            else
                            {
                              removeFromList(mTempList[index]);
                            }



                            //}
                          }),
                          Text("${mTempList[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                          IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                            print("ADDDD");
                            setState(() {
                              mTempList[index].count++;
                              // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                            });
                            // addToCart(mMenuList[index]);
                            widget.callback1();
                            widget.func1('ADD');
                          })
                        ],
                      ),
                    ):Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(3)),
                          color: Colors.grey),
                      child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12),
                          )),
                    ),
                  ],
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                ),
              )
            ],
          ),
        ),
      );
    });
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
  AutoScrollController controller;
  Widget _wrapScrollTag({int index, Widget child})
  => AutoScrollTag(
    key: ValueKey(index),
    controller: controller,
    index: index,
    child: child,
    highlightColor: Colors.black.withOpacity(0.1),
  );

  bool enableScroll = true;
  ScrollController scrollController;
  _scrollListener() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;
    double delta = 270.0; // o

    if ( maxScroll- currentScroll >160) { // whatever you determine here
      //.. load more
      setState(() {
        isStretched = true;
      });

    }
    else if(currentScroll>10)
    {
      setState(() {
        isStretched = false;
      });
    }
   // _runExpandCheck();
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
        if(mounted)
          {
            setState(() {
              mCategoryList = mCategoryRespose.data;
              // hashKey = mCategoryRespose.data[0].hashCode.toString();
              category = "";
              if(hashKey !=null)
              {

                getMenuAPI();
              }

            });
          }
        //CommonMethods.showShortToast(mDeliveryLocationsResponse.);

      }
      else if(onData.status == Status.ERROR)
      {
        // CommonMethods.hideDialog();
        CommonMethods.showShortToast(onData.message);
      }
    });
  }

  MenuBloc mMenuBloc;
  MenuResponse mMenuResponse;
  List<Menu> mMenuList = new List();

  List<FoodItem> foodList = new List();
  getMenuAPI() {
      final body = jsonEncode({"hash":hashKey,"category":category});
      mMenuBloc=MenuBloc(body);
      mMenuBloc.dataStream.listen((onData){
      mMenuResponse = onData.data;
      if(onData.status == Status.LOADING)
      {
        //CommonMethods.displayProgressDialog(onData.message,context);
      }
      else if(onData.status == Status.COMPLETED)
      {
        //CommonMethods.hideDialog();
        setState(() {
          isMenuCalled= true;
          mMenuList = mMenuResponse.menu;


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
    SharedPreferences preferences;
   getDeliveryAddress() async{
    print("get address");
    preferences = await SharedPreferences.getInstance();
    setState(() {
      if(preferences.getString(DELIVERY_PICKUP) =="1")
        {
          deliveryAddressName = preferences.get(DELIVERY_ADDRESS_NAME);
          hashKey = preferences.get(DELIVERY_ADDRESS_HASH);

        }
      else
        {
          if(preferences.get(PICKUP_ADDRESS_NAME)!=null)
          {
            pickupAddressName = preferences.get(PICKUP_ADDRESS_NAME);
          }
          hashKey = preferences.get(PICKUP_ADDRESS_HASH);
        }
      print("HASS $hashKey ${preferences.get(TOGGLE_VALUE)}");
    });

    if(preferences.get(TOGGLE_VALUE) !=null)
    {
      if(preferences.get(TOGGLE_VALUE)=="0")
      {
        print("Zero");
        setState(() {
          status = false; //delivery
        });
      }
      else
      {
        print("One");
        setState(() {
          status = true; //pickup
        });
      }
    }
    else{
      setState(() {
        status=false;
      });
    }
    print("VALUE $status");

  }

  SliderBloc mSliderBloc;
   slider.SliderResponse mSliderResponse;
   List<slider.Data> sliderList = new List();

  callSliderApi() async
  {
    mSliderBloc=SliderBloc();
    mSliderBloc.dataStream.listen((onData){
      mSliderResponse = onData.data;
      //print(onData.status);
      if(onData.status == Status.LOADING)
      {
        // CommonMethods.displayProgressDialog(onData.message,context);
        CommonMethods.showLoaderDialog(context,onData.message);
      }
      else if(onData.status == Status.COMPLETED)
      {
       if(mounted)
         {
           CommonMethods.dismissDialog(context);
           setState(() {
             sliderList.clear();
             sliderList=mSliderResponse.data;
           });
         }
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
  }

   showWarningDialog(String from) {
     showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context){
           return WillPopScope(
             onWillPop: (){},
             child: AlertDialog(
               contentPadding: EdgeInsets.only(top: 0,bottom: 0,right: 20,left: 20),
               title: Text("Warning",style: TextStyle(color: fab_color),),
               content: Padding(
                 padding: const EdgeInsets.only(top:8.0),
                 child: Text("Switching address type will remove all items from cart."),
               ),
               actions: <Widget>[FlatButton(onPressed: () {
                 Navigator.of(context).pop();
                 bloc.clearCart();
                 if(from=="p")
                   {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => PickupAddressScreen()));
                   }
                 else
                   {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
                   }
               }, child: Text("Ok",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),))
               ],
             ),
           );
         }
     );
   }
}


