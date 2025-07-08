import 'dart:convert';

class WarisanResponseModel {
  final String? message;
  final int? statusCode;
  final List<Warisan>? data;

  WarisanResponseModel({this.message, this.statusCode, this.data});

  factory WarisanResponseModel.fromJson(String str) => WarisanResponseModel.fromMap(json.decode(str));

  factory WarisanResponseModel.fromMap(Map<String, dynamic> json) => WarisanResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<Warisan>.from(json["data"].map((x) => Warisan.fromMap(x))),
      );
}

class Warisan {
  final int? id;
  final int? assetId;
  final int? keluargaId;

  Warisan({this.id, this.assetId, this.keluargaId});

  factory Warisan.fromMap(Map<String, dynamic> json) => Warisan(
        id: json["id"],
        assetId: json["asset_id"],
        keluargaId: json["keluarga_id"],
      );
}