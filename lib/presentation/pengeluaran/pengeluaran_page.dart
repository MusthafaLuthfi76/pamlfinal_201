import 'package:emas_app/presentation/pengeluaran/pengeluaran_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_state.dart';

class HomePengeluaranPage extends StatelessWidget {
  const HomePengeluaranPage({Key? key}) : super(key: key);

  final Color goldColor = const Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengeluaranBloc>().add(LoadPengeluaran());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Kelola Pengeluaran", style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPengeluaranPage()),
          );
        },
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PengeluaranBloc, PengeluaranState>(
        builder: (context, state) {
          if (state is PengeluaranLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PengeluaranLoaded) {
            final list = state.pengeluaranList;
            if (list.isEmpty) {
              return const Center(child: Text("Belum ada data pengeluaran."));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final p = list[index];
                return Card(
                  elevation: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      p.namaAset ?? 'Tanpa Nama',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Tanggal: ${p.tanggal}"),
                        Text("Harga: Rp${p.harga?.toStringAsFixed(0) ?? '0'}"),
                        if (p.keterangan != null && p.keterangan!.isNotEmpty)
                          Text("Keterangan: ${p.keterangan}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<PengeluaranBloc>().add(DeletePengeluaran(p.id!));
                      },
                    ),
                  ),
                );
              },
            );
          }

          if (state is PengeluaranError) {
            return Center(child: Text('Gagal memuat data: ${state.message}'));
          }

          return const Center(child: Text("Tidak ada data."));
        },
      ),
    );
  }
}