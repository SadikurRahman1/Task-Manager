class UserModel {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;
  String? createdDate;

  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}';
  }

  UserModel(
      {this.sId,
        this.email,
        this.firstName,
        this.lastName,
        this.mobile,
        this.photo,
        this.createdDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['photo'] = photo;
    data['createdDate'] = createdDate;
    return data;
  }
}
