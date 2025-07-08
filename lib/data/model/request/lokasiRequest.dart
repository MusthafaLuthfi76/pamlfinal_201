class LokasiRequest {
  final String nama;
  final double? latitude;
  final double? longitude;

  LokasiRequest({
    required this.nama,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "latitude": latitude,
    "longitude": longitude,
  };
}
