class ApplyLoyaltyResponse {
  int status;
  String applyDiscount;

  ApplyLoyaltyResponse({this.status, this.applyDiscount});

  ApplyLoyaltyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    applyDiscount = json['apply_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['apply_discount'] = this.applyDiscount;
    return data;
  }
}
