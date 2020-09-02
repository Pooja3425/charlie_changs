class RegisterResponse {
  int exist;
  String status;
  String msg;

  RegisterResponse({this.exist, this.status, this.msg});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    exist = json['exist'];
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exist'] = this.exist;
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}
