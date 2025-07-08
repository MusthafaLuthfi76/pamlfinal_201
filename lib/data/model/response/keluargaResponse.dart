import 'dart:convert';

class KeluargaResponseModel {
  final String? message;
  final int? statusCode;
  final List<Keluarga>? data;

  KeluargaResponseModel({this.message, this.statusCode, this.data});

  factory KeluargaResponseModel.fromJson(String str) => KeluargaResponseModel.fromMap(json.decode(str));

  factory KeluargaResponseModel.fromMap(Map<String, dynamic> json) => KeluargaResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<Keluarga>.from(json["data"].map((x) => Keluarga.fromMap(x))),
      );
}

class Keluarga {
  final int? keluargaId;
  final String? nama;
  final int? kategoriKeluargaId;
  final String? status;
  final String? istri;
  final int? jumlahAnak;

  Keluarga({
    this.keluargaId,
    this.nama,
    this.kategoriKeluargaId,
    this.status,
    this.istri,
    this.jumlahAnak,
  });

  factory Keluarga.fromMap(Map<String, dynamic> json) => Keluarga(
        keluargaId: json["keluarga_id"],
        nama: json["nama"],
        kategoriKeluargaId: json["kategori_keluarga_id"],
        status: json["status"],
        istri: json["istri"],
        jumlahAnak: json["jumlah_anak"],
      );
}
