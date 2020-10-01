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

  double totalCartValue;
  double calculateTotal() {
    totalCartValue = 0;
    foodItems.forEach((f) {
      totalCartValue += double.parse(f.price) * f.count;
    });
    return totalCartValue;
  }

  double removeValTotal() {
    totalCartValue = 0;
    totalCartValue = calculateTotal();
    print("REMOVE TOTAL $totalCartValue");
    return totalCartValue;
  }

  double totalTaxValue;
  double calculateTax() {
    totalTaxValue = 0;
    foodItems.forEach((f) {
      totalTaxValue += double.parse(f.taxTotal) * f.count;
    });
    return totalTaxValue;
  }

  int cartCount=0;
  int calculateCartCount() {
    cartCount = 0;
    foodItems.forEach((f) {
      cartCount += f.count;
    });
    return cartCount;
  }

  removeAllItems()
  {
    foodItems.clear();
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
