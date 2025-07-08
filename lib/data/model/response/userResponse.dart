import 'dart:convert';

class UsersResponseModel {
  final String? message;
  final int? statusCode;
  final List<User>? data;

  UsersResponseModel({this.message, this.statusCode, this.data});

  factory UsersResponseModel.fromJson(String str) => UsersResponseModel.fromMap(json.decode(str));

  factory UsersResponseModel.fromMap(Map<String, dynamic> json) => UsersResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<User>.from(json["data"].map((x) => User.fromMap(x))),
      );
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? role;

  User({this.id, this.name, this.email, this.role});

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
      );
}
