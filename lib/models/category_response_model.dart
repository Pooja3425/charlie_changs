class CategoryRespose {
  int status;
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
