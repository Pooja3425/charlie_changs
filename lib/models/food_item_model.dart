class FoodItem {
  /*int id;
  String title;
  String hotel;
  double price;
  String imgUrl;*/



  int quantity;
  String mid;
  String category;
  String superCategory;
  String isNonveg;
  String sId;
  String name;
  String image;
  String taxTotal;
  String itemTotal;
  String count;
  String hash;
  String resturantId;
  String status;


  FoodItem(this.quantity, this.mid, this.category, this.superCategory,
      this.isNonveg, this.sId, this.name, this.image, this.taxTotal,
      this.itemTotal, this.count, this.hash, this.resturantId, this.status);

  /* FoodItem({
     this.id,
     this.title,
     this.hotel,
    @required this.price,
    @required this.imgUrl,
    this.quantity = 1,
  });*/

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}