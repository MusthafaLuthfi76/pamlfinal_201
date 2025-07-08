import 'package:emas_app/presentation/keluarga/keluargaForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/keluarga/bloc/keluarga_bloc.dart';

class KeluargaHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelola Keluarga')),
      body: BlocBuilder<KeluargaBloc, KeluargaState>(
        builder: (context, state) {
          if (state is KeluargaLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is KeluargaLoadedState) {
            return ListView.builder(
              itemCount: state.keluargaList.length,
              itemBuilder: (context, index) {
                final keluarga = state.keluargaList[index];
                return ListTile(
                  title: Text(keluarga.nama ?? 'No Name'),
                  subtitle: Text('Status: ${keluarga.status}, Jumlah Anak: ${keluarga.jumlahAnak}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KeluargaFormPage(keluarga: keluarga),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<KeluargaBloc>().add(DeleteKeluargaEvent(keluarga.keluargaId!));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is KeluargaErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No data available.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KeluargaFormPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
