import 'dart:convert';

class AsetListResponseModel {
  final String? message;
  final int? statusCode;
  final List<Aset>? data;

  AsetListResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory AsetListResponseModel.fromJson(String str) =>
      AsetListResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AsetListResponseModel.fromMap(Map<String, dynamic> json) =>
      AsetListResponseModel(
        message: json["message"],
        statusCode: json["status_code"] ?? 200,
        data: json["data"] == null
            ? []
            : List<Aset>.from(json["data"].map((x) => Aset.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
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