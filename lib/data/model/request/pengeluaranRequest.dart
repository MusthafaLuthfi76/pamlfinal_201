class PengeluaranRequest {
  final int assetId;
  final int harga;
  final double berat;
  final String tanggal;
  final String? keterangan;
  final String? namaAset; // ⬅ Tambahan

  PengeluaranRequest({
    required this.assetId,
    required this.harga,
    required this.berat,
    required this.tanggal,
    this.keterangan,
    this.namaAset, // ⬅ Tambahan
  });

  Map<String, dynamic> toMap() {
    return {
      'asset_id': assetId,
      'harga': harga,
      'berat': berat,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'nama_aset': namaAset, // ⬅ Tambahkan ini
    };
  }
}
