class AddOrderResponse {
  String pos;
  int status;
  String msg;

  AddOrderResponse({this.pos, this.status, this.msg});

  AddOrderResponse.fromJson(Map<String, dynamic> json) {
    pos = json['pos'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pos'] = this.pos;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
