class CategoryRespose {
  int status;
  List<Data> data;
  DafaultRest dafaultRest;

  CategoryRespose({this.status, this.data, this.dafaultRest});

  CategoryRespose.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    dafaultRest = json['dafault_rest'] != null
        ? new DafaultRest.fromJson(json['dafault_rest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.dafaultRest != null) {
      data['dafault_rest'] = this.dafaultRest.toJson();
    }
    return data;
  }
}

class Data {
  String sid;
  String name;
  String image;
  String status;

  Data({this.sid, this.name, this.image, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['name'] = this.name;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}

class DafaultRest {
  String id;
  String cityid;
  String name;
  Null latitude;
  Null longitude;
  String status;
  String oldId;
  String zoneId;
  String isMobileDefault;

  DafaultRest(
      {this.id,
        this.cityid,
        this.name,
        this.latitude,
        this.longitude,
        this.status,
        this.oldId,
        this.zoneId,
        this.isMobileDefault});

  DafaultRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityid = json['cityid'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    oldId = json['old_id'];
    zoneId = json['zone_id'];
    isMobileDefault = json['is_mobile_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cityid'] = this.cityid;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['old_id'] = this.oldId;
    data['zone_id'] = this.zoneId;
    data['is_mobile_default'] = this.isMobileDefault;
    return data;
  }
}
