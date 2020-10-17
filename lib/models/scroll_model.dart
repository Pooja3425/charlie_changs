import 'package:flutter/foundation.dart';

class ScrollModel extends ChangeNotifier{

  double scrollPosition;
  bool isScrolling =false;
  bool orderType = true;
  bool getValue() => isScrolling;
  void setScroll(bool val) {
    // This call tells the widgets that are listening to this model to rebuild.
    isScrolling = val;

    notifyListeners();
  }

  bool getOrderType()=>orderType;

  void setOrderType(bool val)
  {
    orderType = val;
    notifyListeners();
  }
}