part of 'keluarga_bloc.dart';

abstract class KeluargaState {}

class KeluargaInitial extends KeluargaState {}

class KeluargaLoadingState extends KeluargaState {}

class KeluargaLoadedState extends KeluargaState {
  final List<Keluarga> keluargaList;
  KeluargaLoadedState(this.keluargaList);
}

class KeluargaErrorState extends KeluargaState {
  final String message;
  KeluargaErrorState(this.message);
}
