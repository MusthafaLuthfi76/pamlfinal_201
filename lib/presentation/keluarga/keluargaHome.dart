import 'package:emas_app/data/model/response/keluargaResponse.dart';
import 'package:emas_app/presentation/keluarga/keluargaDetail.dart';
import 'package:emas_app/presentation/keluarga/keluargaForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';

class KeluargaHomePage extends StatelessWidget {
  const KeluargaHomePage({super.key});

  void _showDeleteDialog(BuildContext context, int keluargaId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus anggota keluarga ini?"),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Hapus"),
            onPressed: () {
              context.read<KeluargaBloc>().add(DeleteKeluargaEvent(keluargaId));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelola Keluarga')),
      body: BlocBuilder<KeluargaBloc, KeluargaState>(
        builder: (context, state) {
          if (state is KeluargaLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is KeluargaLoadedState) {
            if (state.keluargaList.isEmpty) {
              return Center(child: Text("Belum ada data keluarga."));
            }

            return ListView.builder(
              itemCount: state.keluargaList.length,
              itemBuilder: (context, index) {
                final Keluarga keluarga = state.keluargaList[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KeluargaDetailPage(keluarga: keluarga),
                        ),
                      );
                    },
                    title: Text(keluarga.nama ?? 'Tanpa Nama'),
                    subtitle: Text("Status: ${keluarga.status ?? '-'}, Anak: ${keluarga.jumlahAnak ?? 0}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
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
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, keluarga.keluargaId!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is KeluargaErrorState) {
            return Center(child: Text('Terjadi kesalahan: ${state.message}'));
          }
          return Center(child: Text('Tidak ada data.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => KeluargaFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}