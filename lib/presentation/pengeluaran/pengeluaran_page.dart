import 'package:emas_app/presentation/pengeluaran/pengeluaran_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_state.dart';

class HomePengeluaranPage extends StatelessWidget {
  const HomePengeluaranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pastikan pemanggilan event dilakukan di dalam addPostFrameCallback agar tidak men-trigger rebuild infinite
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengeluaranBloc>().add(LoadPengeluaran());
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Data Pengeluaran")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPengeluaranPage()),
          );
        },
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
              return const Center(child: Text("Belum ada data pengeluaran"));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final p = list[index];
                return ListTile(
                  title: Text('${p.namaAset ?? 'Unknown'} - Rp${p.harga}'),
                  subtitle: Text(
                    'Tanggal: ${p.tanggal}\nHarga: Rp${p.harga} - ${p.keterangan ?? ''}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => context.read<PengeluaranBloc>().add(DeletePengeluaran(p.id!)),
                  ),
                );
              },
            );
          }

          if (state is PengeluaranError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
