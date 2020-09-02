class RedeemOTPResponse {
  int status;
  String number;
  Otp otp;
  String msg;

  RedeemOTPResponse({this.status, this.number, this.otp, this.msg});

  RedeemOTPResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    number = json['number'];
    otp = json['otp'] != null ? new Otp.fromJson(json['otp']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['number'] = this.number;
    if (this.otp != null) {
      data['otp'] = this.otp.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Otp {
  String rewardOtp;

  Otp({this.rewardOtp});

  Otp.fromJson(Map<String, dynamic> json) {
    rewardOtp = json['reward_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reward_otp'] = this.rewardOtp;
    return data;
  }
}
