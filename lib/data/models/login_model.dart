import 'package:task_manager/data/models/user_model.dart';

class LoginModel {
  String? status;
  UserModel? data;
  String? token;

  LoginModel({
    this.status,
    this.data,
    this.token,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    return data;
  }
}
