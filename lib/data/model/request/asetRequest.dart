class AsetRequest {
  final String nama;
  final int kategoriAsetId;
  final int lokasiId;
  final double berat;
  final double harga;
  final String? foto; // opsional

  AsetRequest({
    required this.nama,
    required this.kategoriAsetId,
    required this.lokasiId,
    required this.berat,
    required this.harga,
    this.foto,
  });

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "kategori_aset_id": kategoriAsetId,
    "lokasi_id": lokasiId,
    "berat": berat,
    "harga": harga,
    "foto": foto,
  };
}
