class Pengeluaran {
  final int id;
  final int assetId;
  final String? namaAset; // <-- tambahkan ini
  final double berat;
  final int harga;
  final DateTime tanggal;
  final String? keterangan;

  Pengeluaran({
    required this.id,
    required this.assetId,
    this.namaAset, // <-- tambahkan ini
    required this.berat,
    required this.harga,
    required this.tanggal,
    this.keterangan,
  });

  factory Pengeluaran.fromMap(Map<String, dynamic> map) {
    return Pengeluaran(
      id: map['id'],
      assetId: map['asset_id'],
      namaAset: map['nama_aset'], // <-- tambahkan ini
      berat: (map['berat'] as num).toDouble(),
      harga: map['harga'],
      tanggal: DateTime.parse(map['tanggal']),
      keterangan: map['keterangan'],
    );
  }
}
