import 'dart:io';

import 'package:flutter/material.dart';
import 'package:emas_app/data/model/response/asetResponse.dart';
import 'package:emas_app/data/model/response/lokasiResponse.dart';
import 'package:emas_app/data/repository/lokasiRepository.dart';

class DetailAsetPage extends StatefulWidget {
  final Aset aset;
  const DetailAsetPage({Key? key, required this.aset}) : super(key: key);

  @override
  State<DetailAsetPage> createState() => _DetailAsetPageState();
}

class _DetailAsetPageState extends State<DetailAsetPage> {
  final lokasiRepo = LokasiRepository();
  String? lokasiName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLokasi();
  }

  Future<void> _loadLokasi() async {
    try {
      final lokasiList = await lokasiRepo.getAll();
      final lokasiObj = lokasiList
          .map((e) => Lokasi.fromMap(e as Map<String, dynamic>))
          .firstWhere((e) => e.lokasiId == widget.aset.lokasiId, orElse: () => Lokasi(lokasiId: 0, nama: 'Tidak diketahui'));
      setState(() {
        lokasiName = lokasiObj.nama;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        lokasiName = "Gagal mengambil lokasi";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aset = widget.aset;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Aset"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text('Nama Aset:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(aset.nama ?? '-'),
                    const SizedBox(height: 12),

                    Text('Berat (gram):', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${aset.berat ?? 0} gram'),
                    const SizedBox(height: 12),

                    Text('Harga:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Rp ${aset.harga?.toStringAsFixed(0) ?? '0'}'),
                    const SizedBox(height: 12),

                    Text('Lokasi:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(lokasiName ?? '-'),
                    const SizedBox(height: 12),

                    Text('Kategori ID:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${aset.kategoriAsetId ?? '-'}'),
                    const SizedBox(height: 12),

                    if (aset.foto != null && aset.foto!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Foto Aset:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Image.network(
                          'http://192.168.0.185:3000${aset.foto!}', // ganti IP sesuai backend-mu
                          errorBuilder: (context, error, stackTrace) {
                            return Text("Gagal menampilkan gambar");
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
