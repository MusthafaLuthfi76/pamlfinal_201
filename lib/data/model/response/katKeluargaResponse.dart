import 'dart:convert';

class KategoriKeluargaResponseModel {
  final String? message;
  final int? statusCode;
  final List<KategoriKeluarga>? data;

  KategoriKeluargaResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory KategoriKeluargaResponseModel.fromJson(String str) =>
      KategoriKeluargaResponseModel.fromMap(json.decode(str));

  factory KategoriKeluargaResponseModel.fromMap(Map<String, dynamic> json) =>
      KategoriKeluargaResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<KategoriKeluarga>.from(
                json["data"].map((x) => KategoriKeluarga.fromMap(x))),
      );
}

class KategoriKeluarga {
  final int? id;
  final String? name;

  KategoriKeluarga({this.id, this.name});

  factory KategoriKeluarga.fromJson(String str) =>
      KategoriKeluarga.fromMap(json.decode(str));

  factory KategoriKeluarga.fromMap(Map<String, dynamic> json) => KategoriKeluarga(
        id: json["kategori_keluarga_id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "kategori_keluarga_id": id,
        "name": name,
      };
}
