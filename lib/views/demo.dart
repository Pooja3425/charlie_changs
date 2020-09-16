import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {



  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

//noti order
   /* {notification: {title: Order Received, body: Thanks for ordering. Order ref :QGLQK5392}, data: {n_type: order, click_action: FLUTTER_NOTIFICATION_CLICK, n_type_id: QGLQK5392}}*/

//general

    /*{notification: {title: test, body: test}, data: {n_type: general, click_action: FLUTTER_NOTIFICATION_CLICK, n_type_id: 36}}*/


class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;
  bool isExpand = true;
  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if(isExpand) {
      expandController.forward();
    }
    else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: animation,
                child: Image.asset("assets/images/image.png",height: 200,)
            ),
            FlatButton(onPressed: (){
              if(isExpand)
                {
                  setState(() {
                    isExpand = false;
                  });
                }
              else
                {
                  setState(() {
                    isExpand = true;
                  });
                }
            }, child: Text("av $isExpand"))
          ],
        ),
      ),
    );
  }
}