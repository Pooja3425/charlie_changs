class AddOrderResponse {
  String rest_bobile;
  String rest_name;
  String pos;
  int status;
  String msg;
  String ordercode;

  AddOrderResponse({this.pos, this.ordercode, this.status, this.msg,this.rest_bobile,this.rest_name});

  AddOrderResponse.fromJson(Map<String, dynamic> json) {
    rest_bobile = json['rest_bobile'];
    rest_name = json['rest_name'];
    pos = json['pos'];
    ordercode = json['ordercode'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rest_bobile'] = this.rest_bobile;
    data['rest_name'] = this.rest_name;
    data['pos'] = this.pos;
    data['ordercode'] = this.ordercode;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
