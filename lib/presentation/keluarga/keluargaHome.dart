import 'package:emas_app/data/model/response/keluargaResponse.dart';
import 'package:emas_app/presentation/keluarga/keluargaDetail.dart';
import 'package:emas_app/presentation/keluarga/keluargaForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';

class KeluargaHomePage extends StatefulWidget {
  const KeluargaHomePage({super.key});

  @override
  State<KeluargaHomePage> createState() => _KeluargaHomePageState();
}

class _KeluargaHomePageState extends State<KeluargaHomePage> {
  int _currentIndex = 2;
  final Color goldColor = const Color(0xFFFFD700);

  void _showDeleteDialog(BuildContext context, int keluargaId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus anggota keluarga ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
            onPressed: () {
              context.read<KeluargaBloc>().add(DeleteKeluargaEvent(keluargaId));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/aset');
    } else if (index == 2) {
      // stay in keluarga
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kelola Keluarga', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocBuilder<KeluargaBloc, KeluargaState>(
        builder: (context, state) {
          if (state is KeluargaLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KeluargaLoadedState) {
            if (state.keluargaList.isEmpty) {
              return const Center(child: Text("Belum ada data keluarga."));
            }

            return ListView.builder(
              itemCount: state.keluargaList.length,
              itemBuilder: (context, index) {
                final Keluarga keluarga = state.keluargaList[index];

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 1.5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KeluargaDetailPage(keluarga: keluarga),
                        ),
                      );
                    },
                    leading: const CircleAvatar(child: Icon(Icons.family_restroom)),
                    title: Text(keluarga.nama ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Status: \${keluarga.status ?? '-'}, Anak: \${keluarga.jumlahAnak ?? 0}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
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
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, keluarga.keluargaId!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is KeluargaErrorState) {
            return Center(child: Text('Terjadi kesalahan: \${state.message}'));
          }
          return const Center(child: Text('Tidak ada data.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => KeluargaFormPage()),
          );
        },
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: goldColor,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Aset'),
          BottomNavigationBarItem(icon: Icon(Icons.family_restroom_outlined), label: 'Keluarga'),
        ],
      ),
    );
  }
}