import 'dart:convert';
class LokasiResponseModel {
  final String? message;
  final int? statusCode;
  final List<Lokasi>? data;

  LokasiResponseModel({this.message, this.statusCode, this.data});

  factory LokasiResponseModel.fromJson(String str) => LokasiResponseModel.fromMap(json.decode(str));

  factory LokasiResponseModel.fromMap(Map<String, dynamic> json) => LokasiResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<Lokasi>.from(json["data"].map((x) => Lokasi.fromMap(x))),
      );
}

class Lokasi {
  final int? lokasiId;
  final String? nama;
  final double? latitude;
  final double? longitude;

  Lokasi({this.lokasiId, this.nama, this.latitude, this.longitude});

  factory Lokasi.fromMap(Map<String, dynamic> json) => Lokasi(
        lokasiId: json["lokasi_id"],
        nama: json["nama"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );
}
