import 'package:badges/badges.dart';
import 'package:charliechang/blocs/cart_bloc.dart';
import 'package:charliechang/utils/color_constants.dart';
import 'package:charliechang/utils/size_constants.dart';
import 'package:charliechang/views/cart_screen.dart';
import 'package:charliechang/views/offers_screen.dart';
import 'package:charliechang/views/updates_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'more_screen.dart';

class BottomScreen extends StatefulWidget {
  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  PageController _pageController;
  int _page=0;
  @override
  void initState() {
    _pageController = new PageController();
    super.initState();
  }
  void onPageChanged(int page){
    setState(() {
      this._page = page;
    });
  }
  String appBarTitle = 'Dashboard';
  void navigationTapped(int page) {
    if (page == 0) {
      appBarTitle = 'Dashboard';
    }
    else if (page == 1) {
      appBarTitle = 'Announcements';
    }
    else if (page == 2) {
      appBarTitle = 'Personal Profile';
    }
    else if (page == 3) {
      appBarTitle = 'Sync Cases';
    }

    // Animating to the page.
    // You can use whatever duration and curve you like

    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
  bool showBadge= true;
  int badgeData = 0;
  Widget callpage(int currentIndex) {
   /* var bloc = Provider.of<CartBloc>(context);
    int totalCount = 0;
    if (bloc.cart.length > 0) {
      totalCount = bloc.cart.values.reduce((a, b) => a + b);
    }*/
    switch (currentIndex) {
      case 0:
        return HomeScreen(
          callback1: () {
            showBadge = true;
            setState(() {});
          },
          func1: (string) {
            if (string == 'ADD') {
              badgeData ++;
            } else if (string == 'REMOVE') {
              badgeData--;
            }
            setState(() {});
          },
        );
      case 1:
        return OffersScreen();
        break;
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*callpage(_page)*/Container(
        height: getHeight(context),
        child: new PageView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            new HomeScreen(
              callback1: () {
                showBadge = true;
                setState(() {});
              },
              func1: (string) {
                if (string == 'ADD') {
                  badgeData++;
                } else if (string == 'REMOVE') {
                  badgeData--;
                }
                setState(() {});
              },
            ),
            new OffersScreen(),
            new CartScreen(),
            new UpdatesScreen(),
            new MoreScreen()
          ],
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
      ),
      bottomNavigationBar: new Theme(
        isMaterialAppTheme: false,
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: const Color(0xFFFFFFFF),
        ), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          selectedItemColor: fab_color,
          unselectedItemColor: icon_color,
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
                icon:  Image.asset(
                  'assets/images/home.png', height: 15, width: 15,color: _page==0?fab_color:icon_color,),
                title: new Text(
                  "Home",style: TextStyle(color: _page==0?fab_color:icon_color,fontSize: 12),
                )),

            new BottomNavigationBarItem(
                icon:  Image.asset(
                  'assets/images/offers.png', height: 15,
                  width: 15,color: _page==1?fab_color:icon_color,),
                title: new Text(
                  "offers",style: TextStyle(color: _page==1?fab_color:icon_color,fontSize: 12),

                )),
            new BottomNavigationBarItem(
                icon: Badge(
                  shape: BadgeShape.circle,
                  badgeContent: Text(
                    badgeData.toString(),
                    style: TextStyle(color: Colors.white,fontSize: 10),
                  ),
                  child: Image.asset(
                    'assets/images/cart.png', height: 15, width: 15,color: _page==2?fab_color:icon_color,),
                ),
                title: new Text(
                  "Cart",style: TextStyle(color: _page==2?fab_color:icon_color,fontSize: 12),

                )),
            new BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/updates.png', height: 15,
                  width: 15,color: _page==3?fab_color:icon_color,),
                title: new Text(
                  "Updates",style: TextStyle(color: _page==3?fab_color:icon_color,fontSize: 12),
                )),
            new BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/more.png', height: 15,
                  width: 15,color: _page==4?fab_color:icon_color,),
                title: new Text(
                  "More",style: TextStyle(color: _page==4?fab_color:icon_color,fontSize: 12),
                )),
          ],
          onTap: navigationTapped,
         /* onTap: (index) {
            setState(() {
              _page = index;
            });
          },*/
          currentIndex: _page,


          //selectedItemColor: Colors.amber[800],

        ),
      ),
    );
  }
}
