class KeluargaRequest {
  final String nama;
  final int? kategoriKeluargaId;
  final String? status;
  final String? istri;
  final int? jumlahAnak;

  KeluargaRequest({
    required this.nama,
    this.kategoriKeluargaId,
    this.status,
    this.istri,
    this.jumlahAnak,
  });

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "kategori_keluarga_id": kategoriKeluargaId,
    "status": status,
    "istri": istri,
    "jumlah_anak": jumlahAnak,
  };
}
