import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_bloc.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_event.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_state.dart';
import 'package:emas_app/presentation/warisan/warisan_form.dart';

class WarisanHomePage extends StatelessWidget {
  const WarisanHomePage({super.key});

  final Color goldColor = const Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kelola Warisan", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<WarisanBloc, WarisanState>(
        listener: (context, state) {
          if (state is WarisanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is WarisanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WarisanLoaded) {
            final warisanList = state.data;
            if (warisanList.isEmpty) {
              return const Center(child: Text("Belum ada data warisan."));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: warisanList.length,
              itemBuilder: (context, index) {
                final item = warisanList[index];

                return Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      "${item['nama_aset'] ?? 'Tanpa Nama'}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Untuk: ${item['nama_keluarga'] ?? '-'}"),
                        Text("Berat: ${item['berat'] ?? '0'} gram"),
                        Text("Harga: Rp${item['harga'] ?? '0'}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<WarisanBloc>(),
                                  child: WarisanFormPage(editData: item),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<WarisanBloc>().add(DeleteWarisan(item['id']));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is WarisanFailure) {
            return Center(child: Text("Gagal memuat data: ${state.message}"));
          }

          return const Center(child: Text("Tidak ada data."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<WarisanBloc>(),
                child: const WarisanFormPage(),
              ),
            ),
          );
        },
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}