class SpecialOffers
{
  String name,id;
  String price,key;
  bool isApplied;
  SpecialOffers({this.name,this.price,this.id,this.key,this.isApplied});
  SpecialOffers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    id = json['pos_item_id'];
  }
}