import 'dart:convert';

class AsetResponseModel {
  final String? message;
  final int? statusCode;
  final Aset? data;

  AsetResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory AsetResponseModel.fromJson(String str) => AsetResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AsetResponseModel.fromMap(Map<String, dynamic> json) => AsetResponseModel(
        message: json["message"],
        statusCode: json["status_code"] ?? 200,
        data: json["data"] == null ? null : Aset.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
      };
}

class Aset {
  final int? assetId;
  final String? nama;
  final int? kategoriAsetId;
  final int? lokasiId;
  final double? berat;
  final double? harga;
  final String? foto;

  Aset({
    this.assetId,
    this.nama,
    this.kategoriAsetId,
    this.lokasiId,
    this.berat,
    this.harga,
    this.foto,
  });

  factory Aset.fromJson(String str) => Aset.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Aset.fromMap(Map<String, dynamic> json) => Aset(
        assetId: json["asset_id"],
        nama: json["nama"],
        kategoriAsetId: json["kategori_aset_id"],
        lokasiId: json["lokasi_id"],
        berat: (json["berat"] as num?)?.toDouble(),
        harga: (json["harga"] as num?)?.toDouble(),
        foto: json["foto"],
      );

  Map<String, dynamic> toMap() => {
        "asset_id": assetId,
        "nama": nama,
        "kategori_aset_id": kategoriAsetId,
        "lokasi_id": lokasiId,
        "berat": berat,
        "harga": harga,
        "foto": foto,
      };
}
