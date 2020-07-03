import 'package:charliechang/models/food_item_model.dart';
import 'package:charliechang/models/menu_response_model.dart';

class CartProvider {
  //couterProvider only consists of a counter and a method which is responsible for increasing the value of count
  List<Menu> foodItems = [];

  List<Menu> addToList(Menu foodItem) {
    bool isPresent = false;

    if (foodItems.length > 0) {
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].mid == foodItem.mid) {
          increaseItemQuantity(foodItem);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        foodItems.add(foodItem);
      }
    } else {
      foodItems.add(foodItem);
    }

    return foodItems;
  }

  List<Menu> removeFromList(Menu foodItem) {
   // if (foodItem.count > 1) {
      //only decrease the quantity
      decreaseItemQuantity(foodItem);
      foodItems.remove(foodItem);
    /*} else {
      //remove it from the list
      foodItems.remove(foodItem);
    }*/
    return foodItems;
  }

  void increaseItemQuantity(Menu foodItem) => foodItem.incrementQuantity();
  void decreaseItemQuantity(Menu foodItem) => foodItem.decrementQuantity();
}
