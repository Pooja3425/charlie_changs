class OutletsResponse {
  List<Data> data;

  OutletsResponse({this.data});

  OutletsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String outletName;
  String outletAddress;
  String outletMobile;
  String outletEmail;

  Data(
      {this.outletName,
        this.outletAddress,
        this.outletMobile,
        this.outletEmail});

  Data.fromJson(Map<String, dynamic> json) {
    outletName = json['outlet_name'];
    outletAddress = json['outlet_address'];
    outletMobile = json['outlet_mobile'];
    outletEmail = json['outlet_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet_name'] = this.outletName;
    data['outlet_address'] = this.outletAddress;
    data['outlet_mobile'] = this.outletMobile;
    data['outlet_email'] = this.outletEmail;
    return data;
  }
}
