part of 'kategori_keluarga_bloc.dart';

abstract class KategoriKeluargaState {}

class KategoriKeluargaInitial extends KategoriKeluargaState {}

class KategoriKeluargaLoadingState extends KategoriKeluargaState {}

class KategoriKeluargaLoadedState extends KategoriKeluargaState {
  final List<Map<String, dynamic>> kategoriKeluargaList;
  KategoriKeluargaLoadedState(this.kategoriKeluargaList);
}

class KategoriKeluargaErrorState extends KategoriKeluargaState {
  final String message;
  KategoriKeluargaErrorState(this.message);
}
