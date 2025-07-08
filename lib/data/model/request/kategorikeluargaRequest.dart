class KategoriKeluargaRequest {
  final String nama;

  KategoriKeluargaRequest({required this.nama});

  Map<String, dynamic> toJson() {
    return {'name': nama};
  }
}
