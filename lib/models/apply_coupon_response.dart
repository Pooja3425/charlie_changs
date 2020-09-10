class ApplyCouponReponse {
  String error;
  String status;
  int discount;
  String msg;

  ApplyCouponReponse({this.error,this.status, this.discount, this.msg});

  ApplyCouponReponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
    discount = json['discount'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['msg'] = this.msg;
    return data;
  }
}
