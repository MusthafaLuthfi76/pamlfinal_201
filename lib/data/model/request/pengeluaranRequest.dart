class PengeluaranRequest {
  final int assetId;
  final double berat;
  final int harga;
  final String tanggal;
  final String? keterangan;

  PengeluaranRequest({
    required this.assetId,
    required this.berat,
    required this.harga,
    required this.tanggal,
    this.keterangan,
  });

  Map<String, dynamic> toJson() => {
    "asset_id": assetId,
    "berat": berat,
    "harga": harga,
    "tanggal": tanggal,
    "keterangan": keterangan,
  };
}
