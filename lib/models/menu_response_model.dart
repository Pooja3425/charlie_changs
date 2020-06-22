class MenuResponse {
  String status;
  List<Menu> menu;
  List<Timings> timings;
  int isLive;
  int isOff;

  MenuResponse({this.status, this.menu, this.timings, this.isLive, this.isOff});

  MenuResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['menu'] != null) {
      menu = new List<Menu>();
      json['menu'].forEach((v) {
        menu.add(new Menu.fromJson(v));
      });
    }
    if (json['timings'] != null) {
      timings = new List<Timings>();
      json['timings'].forEach((v) {
        timings.add(new Timings.fromJson(v));
      });
    }
    isLive = json['is_live'];
    isOff = json['is_off'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.menu != null) {
      data['menu'] = this.menu.map((v) => v.toJson()).toList();
    }
    if (this.timings != null) {
      data['timings'] = this.timings.map((v) => v.toJson()).toList();
    }
    data['is_live'] = this.isLive;
    data['is_off'] = this.isOff;
    return data;
  }
}

class Menu {
  String mid;
  String category;
  String superCategory;
  String isNonveg;
  String sId;
  String id;
  String name;
  String image;
  String price;
  String taxTotal;
  String itemTotal;
  String count;
  String hash;
  String resturantId;
  String status;

  Menu(
      {this.mid,
        this.category,
        this.superCategory,
        this.isNonveg,
        this.sId,
        this.id,
        this.name,
        this.image,
        this.price,
        this.taxTotal,
        this.itemTotal,
        this.count,
        this.hash,
        this.resturantId,
        this.status});

  Menu.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    category = json['category'];
    superCategory = json['super_category'];
    isNonveg = json['is_nonveg'];
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    taxTotal = json['tax_total'];
    itemTotal = json['item_total'];
    count = json['count'];
    hash = json['hash'];
    resturantId = json['resturant_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mid'] = this.mid;
    data['category'] = this.category;
    data['super_category'] = this.superCategory;
    data['is_nonveg'] = this.isNonveg;
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['tax_total'] = this.taxTotal;
    data['item_total'] = this.itemTotal;
    data['count'] = this.count;
    data['hash'] = this.hash;
    data['resturant_id'] = this.resturantId;
    data['status'] = this.status;
    return data;
  }
}

class Timings {
  String mstartTime;
  String mcloseTime;
  String estartTime;
  String ecloseTime;
  String holiday;

  Timings(
      {this.mstartTime,
        this.mcloseTime,
        this.estartTime,
        this.ecloseTime,
        this.holiday});

  Timings.fromJson(Map<String, dynamic> json) {
    mstartTime = json['mstart_time'];
    mcloseTime = json['mclose_time'];
    estartTime = json['estart_time'];
    ecloseTime = json['eclose_time'];
    holiday = json['holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mstart_time'] = this.mstartTime;
    data['mclose_time'] = this.mcloseTime;
    data['estart_time'] = this.estartTime;
    data['eclose_time'] = this.ecloseTime;
    data['holiday'] = this.holiday;
    return data;
  }
}
