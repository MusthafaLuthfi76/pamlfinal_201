import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/lokasi/bloc/lokasi_bloc.dart';
import 'package:emas_app/presentation/lokasi/lokasiForm.dart';

class LokasiHomePage extends StatelessWidget {
  const LokasiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Kelola Lokasi',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<LokasiBloc, LokasiState>(
        builder: (context, state) {
          if (state is LokasiLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LokasiLoadedState) {
            if (state.lokasiList.isEmpty) {
              return const Center(child: Text('Belum ada data lokasi'));
            }
            return ListView.builder(
              itemCount: state.lokasiList.length,
              itemBuilder: (context, index) {
                final lokasi = state.lokasiList[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 1.5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(child: Icon(Icons.location_on)),
                    title: Text(
                      lokasi.nama ?? 'Tanpa Nama',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(lokasi.alamat ?? 'Tanpa Alamat'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: context.read<LokasiBloc>(),
                                  child: LokasiFormPage(lokasi: lokasi),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<LokasiBloc>().add(DeleteLokasiEvent(lokasi.lokasiId!));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is LokasiErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Tidak ada data.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<LokasiBloc>(),
                child: const LokasiFormPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

