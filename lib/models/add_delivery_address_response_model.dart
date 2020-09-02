class AddDeliveryAddressRespose {
  String msg;
  String status;

  AddDeliveryAddressRespose({this.msg, this.status});

  AddDeliveryAddressRespose.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}
