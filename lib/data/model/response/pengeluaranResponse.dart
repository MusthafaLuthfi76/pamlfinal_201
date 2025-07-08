import 'dart:convert';
class PengeluaranResponseModel {
  final String? message;
  final int? statusCode;
  final List<Pengeluaran>? data;

  PengeluaranResponseModel({this.message, this.statusCode, this.data});

  factory PengeluaranResponseModel.fromJson(String str) => PengeluaranResponseModel.fromMap(json.decode(str));

  factory PengeluaranResponseModel.fromMap(Map<String, dynamic> json) => PengeluaranResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? [] : List<Pengeluaran>.from(json["data"].map((x) => Pengeluaran.fromMap(x))),
      );
}

class Pengeluaran {
  final int? id;
  final int? assetId;
  final double? berat;
  final int? harga;
  final String? tanggal;
  final String? keterangan;

  Pengeluaran({this.id, this.assetId, this.berat, this.harga, this.tanggal, this.keterangan});

  factory Pengeluaran.fromMap(Map<String, dynamic> json) => Pengeluaran(
        id: json["id"],
        assetId: json["asset_id"],
        berat: json["berat"]?.toDouble(),
        harga: json["harga"],
        tanggal: json["tanggal"],
        keterangan: json["keterangan"],
      );
}
