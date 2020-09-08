import 'package:flutter/foundation.dart';

class ScrollModel extends ChangeNotifier{

  double scrollPosition;
  bool isScrolling =false;
  bool getValue() => isScrolling;
  void setScroll(double val) {
    // This call tells the widgets that are listening to this model to rebuild.
    scrollPosition = val;
    if(scrollPosition>300)
      {
        isScrolling = true;
      }
    else
      {
        isScrolling = false;
      }
    notifyListeners();
  }
}