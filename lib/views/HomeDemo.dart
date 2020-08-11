import 'dart:convert';

import 'package:charliechang/blocs/category_bloc.dart';
import 'package:charliechang/blocs/menu_bloc.dart';
import 'package:charliechang/blocs/slider_bloc.dart' ;
import 'package:charliechang/models/category_response_model.dart';
import 'package:charliechang/models/food_item_model.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:charliechang/models/slider_response.dart' as slider;
import 'package:charliechang/networking/Repsonse.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/common_methods.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/utils/string_constants.dart';
import 'package:flutter/rendering.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:charliechang/models/category_response_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sticky_headers/sticky_headers.dart';



class HomeDemo extends StatefulWidget {
  @override
  _HomeDemoState createState() => _HomeDemoState();
}

class _HomeDemoState extends State<HomeDemo> with TickerProviderStateMixin{

  List<Data> mCategoryList = new List();
  String hashKey,category;
  final scrollDirection = Axis.vertical;
  @override
  void initState() {
   callSliderApi();
   getCategoriesAPI();
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double itemHeight = (getHeight(context) - kToolbarHeight - 24) / 2.1;
    final double itemWidth = getWidth(context) / 2;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
    //statusBar height
    statusBarHeight +
        //pinned SliverAppBar height in header
        kToolbarHeight;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(headerSliverBuilder: (BuildContext c, bool f) {
          return buildSliverHeader();
        },

            body: Column(
              children: <Widget>[
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
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  category = mCategoryList[index].name;
                                  print("$category");

                                  /*for(int i=0;i<mMenuList.length;i++)
                                    {
                                      if(mMenuList[i].category == category)
                                        {
                                          _scrollToIndex(i);
                                          break;

                                        }
                                    }*/

                                  //_scrollToIndex(index);

                                  //getMenuAPI();
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
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: icon_color, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap:true,
                      itemCount: mCategoryList.length,
                      scrollDirection: scrollDirection,
                      controller: controller,
                      itemBuilder: (context,index){
                        return  StickyHeader(
                            header:  Padding(
                              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                              child: Text(
                                "${mCategoryList[index].name}",
                                style: TextStyle(color: icon_color),
                              ),
                            ),
                            content: Container(
                                width: getWidth(context),
                                // height: getHeight(context)/2,
                                child: mMenuList.length>0?GridView.count(

                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  childAspectRatio: (itemWidth / itemHeight),
                                  //controller: new ScrollController(keepScrollOffset: false),
                                  shrinkWrap: true,
                                  children: /*_IsSearching?buildList(_searchList,mCategoryList[index].name):*/buildList(mMenuList,mCategoryList[index].name),
                                ):Center(child: CircularProgressIndicator(),)

                            ),
                          );
                      }),
                )
              ],
            )),
      ),
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

    //  print("Temp size ${mTempList.length}");
    return List.generate(/*mMenuList.length*/mTempList.length, (index) {
      return Column(
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
                mTempList[index].count ==0?InkWell(
                  onTap: (){
                    //final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
                    /*addToCart(mTempList[index]);

                    //bloc.addToCart(index);
                    widget.callback1();
                    widget.func1('ADD');
                    setState(() {
                      //
                      // mMenuList[index].count ++;
                    });*/
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
                        print("SIZEEE ${mMenuList[index].count}");
/*
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
                        }*/



                        //}
                      }),
                      Text("${mTempList[index].count}",style: TextStyle(color: button_color,fontSize: 13),),
                      IconButton(icon: Icon(Icons.add,color: button_color,size: 15,), onPressed: (){
                        /*print("ADDDD");
                        setState(() {
                          mTempList[index].count++;
                          // orderModelList[index].price = orderModelList[index].price*orderModelList[index].count;
                        });
                        // addToCart(mMenuList[index]);
                        widget.callback1();
                        widget.func1('ADD');*/
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
    });
  }

  Future _scrollToIndex(int index) async {
    print("Anchot");
    /* setState(() {
      counter++;

      if (counter >= mCategoryList.length)
        counter = 0;
    });*/

    await controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    controller.highlight(index);
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

  List<Widget> buildSliverHeader() {
    final List<Widget> widgets = <Widget>[];
    widgets.add(
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 250.0,
          floating: false,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            background:sliderList.length>0?GFCarousel(
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
                  return Container(
                    //margin: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      //borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Image.network(IMAGE_BASE_URL+url.imagePath,
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
            ):Container(),
          ),
           /**/
        ));

    return widgets;
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
        CommonMethods.dismissDialog(context);
        setState(() {
          sliderList.clear();
          sliderList=mSliderResponse.data;
        });
      }
      else if(onData.status == Status.ERROR)
      {
        CommonMethods.dismissDialog(context);
        CommonMethods.showShortToast(onData.message);

      }
    });
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
          // hashKey = mCategoryRespose.data[0].hashCode.toString();
          category = "";
          if(hashKey !=null)
          {

            getMenuAPI();
          }

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
          //isMenuCalled= true;
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
}
