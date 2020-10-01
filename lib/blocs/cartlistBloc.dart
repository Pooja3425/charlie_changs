import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charliechang/blocs/provider.dart';
import 'package:charliechang/models/food_item_model.dart';
import 'package:charliechang/models/menu_response_model.dart';
import 'package:rxdart/rxdart.dart';


class CartListBloc extends BlocBase {
  CartListBloc();

  var _listController = BehaviorSubject<List<Menu>>.seeded([]);

//provider class
  CartProvider provider = CartProvider();

//output
  Stream<List<Menu>> get listStream => _listController.stream;

//input
  Sink<List<Menu>> get listSink => _listController.sink;

  addToList(Menu foodItem) {
    listSink.add(provider.addToList(foodItem));
  }

  removeFromList(Menu foodItem) {
    listSink.add(provider.removeFromList(foodItem));
    
  }

  clearCart()
  {
    provider.removeAllItems();
  }
  double getCartValue()
  {
    return provider.calculateTotal();
  }

  double getRemoveValue()
  {
    return provider.removeValTotal() ;
  }

  double getTax()
  {
    return provider.calculateTax();
  }

  int getCartCount()
  {
    return provider.calculateCartCount();
  }
//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
