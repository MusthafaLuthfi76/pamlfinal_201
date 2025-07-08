import 'dart:convert';

class KategoriAsetResponseModel {
  final String? message;
  final int? statusCode;
  final List<KategoriAset>? data;

  KategoriAsetResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory KategoriAsetResponseModel.fromJson(String str) =>
      KategoriAsetResponseModel.fromMap(json.decode(str));

  factory KategoriAsetResponseModel.fromMap(Map<String, dynamic> json) =>
      KategoriAsetResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<KategoriAset>.from(
                json["data"].map((x) => KategoriAset.fromMap(x))),
      );
}

class KategoriAset {
  final int? id;
  final String? name;

  KategoriAset({this.id, this.name});

  factory KategoriAset.fromJson(String str) =>
      KategoriAset.fromMap(json.decode(str));

  factory KategoriAset.fromMap(Map<String, dynamic> json) => KategoriAset(
        id: json["kategori_aset_id"], // ✅ sesuai dengan nama field di API
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "kategori_aset_id": id,
        "name": name,
      };
}