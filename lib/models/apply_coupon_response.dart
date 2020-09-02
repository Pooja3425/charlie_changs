class ApplyCouponReponse {
  String status;
  int discount;
  String msg;

  ApplyCouponReponse({this.status, this.discount, this.msg});

  ApplyCouponReponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    discount = json['discount'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['msg'] = this.msg;
    return data;
  }
}
