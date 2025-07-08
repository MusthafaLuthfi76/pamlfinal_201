import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/lokasi/bloc/lokasi_bloc.dart';
import 'package:emas_app/presentation/lokasi/lokasiForm.dart';

class LokasiHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lokasi Management')),
      body: BlocBuilder<LokasiBloc, LokasiState>(
        builder: (context, state) {
          if (state is LokasiLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LokasiLoadedState) {
            return ListView.builder(
              itemCount: state.lokasiList.length,
              itemBuilder: (context, index) {
                final lokasi = state.lokasiList[index];
                return ListTile(
                  title: Text(lokasi.nama ?? 'No Name'),
                  subtitle: Text('Lat: ${lokasi.latitude}, Long: ${lokasi.longitude}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
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
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<LokasiBloc>().add(DeleteLokasiEvent(lokasi.lokasiId!));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is LokasiErrorState) {
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
              builder: (context) => BlocProvider.value(
                value: context.read<LokasiBloc>(),
                child: LokasiFormPage(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
