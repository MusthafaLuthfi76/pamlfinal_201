import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_bloc.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_event.dart';
import 'package:emas_app/presentation/warisan/bloc/warisan_state.dart';
import 'package:emas_app/presentation/warisan/warisan_form.dart';

class WarisanHomePage extends StatelessWidget {
  const WarisanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Warisan")),
      body: BlocConsumer<WarisanBloc, WarisanState>(
        listener: (context, state) {
          if (state is WarisanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is WarisanLoading) return Center(child: CircularProgressIndicator());
          if (state is WarisanLoaded) {
            final warisanList = state.data;
            return ListView.builder(
              itemCount: warisanList.length,
              itemBuilder: (context, index) {
                final item = warisanList[index];
                return ListTile(
                  title: Text("${item['nama_aset']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Untuk: ${item['nama_keluarga']}"),
                      Text("Berat: ${item['berat']} gram"),
                      Text("Harga: Rp${item['harga']}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
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
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<WarisanBloc>().add(DeleteWarisan(item['id']));
                        },
                      ),
                    ],
                  ),
                );

              },
            );
          }
          if (state is WarisanFailure) return Center(child: Text(state.message));
          return Center(child: Text("Belum ada data"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<WarisanBloc>(),
                child: WarisanFormPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
