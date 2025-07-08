import 'dart:convert';

class AuthResponseModel {
  final bool? status;
  final String? message;
  final String? token;
  final AuthUser? user;

  AuthResponseModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        user: json["user"] == null ? null : AuthUser.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "token": token,
        "user": user?.toMap(),
      };
}

class AuthUser {
  final int? id;
  final String? name;
  final String? email;
  final String? role;

  AuthUser({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory AuthUser.fromJson(String str) =>
      AuthUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthUser.fromMap(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
      };
}
