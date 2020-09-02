class GetProfileData {
  Data data;
  String status;

  GetProfileData({this.data, this.status});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String firstName;
  String lastName;
  String mobile;
  String email;
  String dob;
  String annDob;

  Data(
      {this.firstName,
        this.lastName,
        this.mobile,
        this.email,
        this.dob,
        this.annDob});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    dob = json['dob'];
    annDob = json['ann_dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['ann_dob'] = this.annDob;
    return data;
  }
}
