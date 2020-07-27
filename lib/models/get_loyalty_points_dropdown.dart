class GetLoyaltyPointsDropdown {
  int id;
  int points;
  SelectPoints selectPoints;

  GetLoyaltyPointsDropdown({this.id, this.points, this.selectPoints});

  GetLoyaltyPointsDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points'];
    selectPoints = json['select_points'] != null
        ? new SelectPoints.fromJson(json['select_points'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['points'] = this.points;
    if (this.selectPoints != null) {
      data['select_points'] = this.selectPoints.toJson();
    }
    return data;
  }
}

class SelectPoints {
  String s11744;

  SelectPoints({this.s11744});

  SelectPoints.fromJson(Map<String, dynamic> json) {
    s11744 = json['11744'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['11744'] = this.s11744;
    return data;
  }
}
