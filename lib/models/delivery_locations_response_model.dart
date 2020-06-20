class DeliveryLocationsResponse {
  List<Delivery> delivery;
  List<Pickup> pickup;
  String status;

  DeliveryLocationsResponse({this.delivery, this.pickup, this.status});

  DeliveryLocationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['delivery'] != null) {
      delivery = new List<Delivery>();
      json['delivery'].forEach((v) {
        delivery.add(new Delivery.fromJson(v));
      });
    }
    if (json['pickup'] != null) {
      pickup = new List<Pickup>();
      json['pickup'].forEach((v) {
        pickup.add(new Pickup.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.delivery != null) {
      data['delivery'] = this.delivery.map((v) => v.toJson()).toList();
    }
    if (this.pickup != null) {
      data['pickup'] = this.pickup.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Delivery {
  String restid;
  String id;
  String name;
  String mov;
  String delTime;
  String areaid;
  String hash;

  Delivery(
      {this.restid,
        this.id,
        this.name,
        this.mov,
        this.delTime,
        this.areaid,
        this.hash});

  Delivery.fromJson(Map<String, dynamic> json) {
    restid = json['restid'];
    id = json['id'];
    name = json['name'];
    mov = json['mov'];
    delTime = json['del_time'];
    areaid = json['areaid'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restid'] = this.restid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['mov'] = this.mov;
    data['del_time'] = this.delTime;
    data['areaid'] = this.areaid;
    data['hash'] = this.hash;
    return data;
  }
}

class Pickup {
  String name;
  String id;
  String address;
  String landmark;
  String pincode;
  String hash;

  Pickup(
      {this.name,
        this.id,
        this.address,
        this.landmark,
        this.pincode,
        this.hash});

  Pickup.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    address = json['address'];
    landmark = json['landmark'];
    pincode = json['pincode'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['pincode'] = this.pincode;
    data['hash'] = this.hash;
    return data;
  }
}
