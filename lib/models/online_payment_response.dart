class OnlinePaymentResponse {
  int orderid;
  String ordercode;
  String pdata;
  String paymentUrl;
  String paymentId;
  int paymentMode;
  String restid;
  int status;
  String type;
  String msg;

  OnlinePaymentResponse(
      {this.orderid,
        this.ordercode,
        this.pdata,
        this.paymentUrl,
        this.paymentId,
        this.paymentMode,
        this.restid,
        this.status,
        this.type,
        this.msg});

  OnlinePaymentResponse.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    ordercode = json['ordercode'];
    pdata = json['pdata'];
    paymentUrl = json['payment_url'];
    paymentId = json['payment_id'];
    paymentMode = json['payment_mode'];
    restid = json['restid'];
    status = json['status'];
    type = json['type'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderid'] = this.orderid;
    data['ordercode'] = this.ordercode;
    data['pdata'] = this.pdata;
    data['payment_url'] = this.paymentUrl;
    data['payment_id'] = this.paymentId;
    data['payment_mode'] = this.paymentMode;
    data['restid'] = this.restid;
    data['status'] = this.status;
    data['type'] = this.type;
    data['msg'] = this.msg;
    return data;
  }
}
