class LoyaltyPointsResponse {
  String status;
  int points;

  LoyaltyPointsResponse({this.status, this.points});

  LoyaltyPointsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['points'] = this.points;
    return data;
  }
}
