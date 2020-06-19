class VerifyOtpResponse {
  String msg;
  String token;
  String firstName;
  String lastName;
  String email;
  String mobile;
  String couponCode;
  String completeProfile;

  VerifyOtpResponse(
      {this.msg,
        this.token,
        this.firstName,
        this.lastName,
        this.email,
        this.mobile,
        this.couponCode,
        this.completeProfile});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    token = json['token'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    couponCode = json['coupon_code'];
    completeProfile = json['complete_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['token'] = this.token;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['coupon_code'] = this.couponCode;
    data['complete_profile'] = this.completeProfile;
    return data;
  }
}
