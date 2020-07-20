class CouponListResponse {
  String status;
  List<Data> data;

  CouponListResponse({this.status, this.data});

  CouponListResponse.fromJson(Map<String, dynamic> json) {
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
  String title;
  String info;
  String fromDate;
  String toDate;
  String fromTime;
  String toTime;
  String isMultiple;
  String isSpecific;
  String minimumOrderValue;
  String restid;
  String isDaySpecific;
  String status;
  String validDays;
  String applicableFor;
  String isFirstTime;
  String isSingleUses;
  String validDevice;
  String isCashback;
  String coupanImage;
  String showApp;

  Data(
      {this.id,
        this.title,
        this.info,
        this.fromDate,
        this.toDate,
        this.fromTime,
        this.toTime,
        this.isMultiple,
        this.isSpecific,
        this.minimumOrderValue,
        this.restid,
        this.isDaySpecific,
        this.status,
        this.validDays,
        this.applicableFor,
        this.isFirstTime,
        this.isSingleUses,
        this.validDevice,
        this.isCashback,
        this.coupanImage,
        this.showApp});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    info = json['info'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    isMultiple = json['is_multiple'];
    isSpecific = json['is_specific'];
    minimumOrderValue = json['minimum_order_value'];
    restid = json['restid'];
    isDaySpecific = json['is_day_specific'];
    status = json['status'];
    validDays = json['valid_days'];
    applicableFor = json['applicable_for'];
    isFirstTime = json['is_first_time'];
    isSingleUses = json['is_single_uses'];
    validDevice = json['valid_device'];
    isCashback = json['is_cashback'];
    coupanImage = json['coupan_image'];
    showApp = json['show_app'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['info'] = this.info;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['is_multiple'] = this.isMultiple;
    data['is_specific'] = this.isSpecific;
    data['minimum_order_value'] = this.minimumOrderValue;
    data['restid'] = this.restid;
    data['is_day_specific'] = this.isDaySpecific;
    data['status'] = this.status;
    data['valid_days'] = this.validDays;
    data['applicable_for'] = this.applicableFor;
    data['is_first_time'] = this.isFirstTime;
    data['is_single_uses'] = this.isSingleUses;
    data['valid_device'] = this.validDevice;
    data['is_cashback'] = this.isCashback;
    data['coupan_image'] = this.coupanImage;
    data['show_app'] = this.showApp;
    return data;
  }
}
