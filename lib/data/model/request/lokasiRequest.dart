class LokasiRequest {
  final String nama;
  final String alamat;

  LokasiRequest({
    required this.nama,
    required this.alamat,
  });

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "alamat": alamat,
      };
}
