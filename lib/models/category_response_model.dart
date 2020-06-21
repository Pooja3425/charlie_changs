class CategoryRespose {
  String status;
  List<Data> data;

  CategoryRespose({this.status, this.data});

  CategoryRespose.fromJson(Map<String, dynamic> json) {
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
  String cid;
  String name;
  String image;
  String status;

  Data({this.cid, this.name, this.image, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['name'] = this.name;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
