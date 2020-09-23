class ApplyCouponReponse {
  String error;
  String status;
  int discount;
  String msg;
  String min_cart_val;

  ApplyCouponReponse({this.error,this.status, this.discount, this.msg,this.min_cart_val});

  ApplyCouponReponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
    discount = json['discount'];
    msg = json['msg'];
    min_cart_val = json['min_cart_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['msg'] = this.msg;
    data['min_cart_val'] = this.min_cart_val;
    return data;
  }
}
