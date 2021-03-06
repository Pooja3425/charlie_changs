class CustomerAddressRespose {
  String status;
  List<Data> data;

  CustomerAddressRespose({this.status, this.data});

  CustomerAddressRespose.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String addressName;
  String address1;
  String address2;
  String isPrimary;
  String areaid;
  String pincode;
  String hash;
  String note;
  String landmark;

  Data(
      {this.id,
        this.addressName,
        this.address1,
        this.address2,
        this.isPrimary,
        this.areaid,
        this.pincode,
        this.hash});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressName = json['address_name'];
    address1 = json['address1'];
    address2 = json['address2'];
    isPrimary = json['is_primary'];
    areaid = json['areaid'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    note = json['note'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_name'] = this.addressName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['is_primary'] = this.isPrimary;
    data['areaid'] = this.areaid;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['note'] = this.note;
    data['hash'] = this.hash;
    return data;
  }
}
