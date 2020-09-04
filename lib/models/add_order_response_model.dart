class AddOrderResponse {
  String pos;
  int status;
  String msg;
  String ordercode;

  AddOrderResponse({this.pos, this.ordercode, this.status, this.msg});

  AddOrderResponse.fromJson(Map<String, dynamic> json) {
    pos = json['pos'];
    ordercode = json['ordercode'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pos'] = this.pos;
    data['ordercode'] = this.ordercode;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
