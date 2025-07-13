import 'package:emas_app/data/model/response/keluargaResponse.dart';
import 'package:emas_app/presentation/keluarga/keluargaForm.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeluargaDetailPage extends StatelessWidget {
  final Keluarga keluarga;

  const KeluargaDetailPage({super.key, required this.keluarga});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Data"),
        content: Text("Yakin ingin menghapus anggota keluarga ini?"),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Hapus"),
            onPressed: () {
              context.read<KeluargaBloc>().add(DeleteKeluargaEvent(keluarga.keluargaId!));
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to list
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("$label:")),
          Expanded(flex: 3, child: Text(value ?? "-")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Keluarga"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KeluargaFormPage(keluarga: keluarga),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Nama", keluarga.nama),
            _buildRow("Status", keluarga.status),
            _buildRow("Istri", keluarga.istri),
            _buildRow("Jumlah Anak", keluarga.jumlahAnak?.toString()),
            _buildRow("Kategori ID", keluarga.kategoriKeluargaId?.toString()),
          ],
        ),
      ),
    );
  }
}
