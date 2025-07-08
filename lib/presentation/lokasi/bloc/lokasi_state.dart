part of 'lokasi_bloc.dart';

abstract class LokasiState {}

class LokasiInitial extends LokasiState {}

class LokasiLoadingState extends LokasiState {}

class LokasiLoadedState extends LokasiState {
  final List<Lokasi> lokasiList;
  LokasiLoadedState(this.lokasiList);
}

class LokasiErrorState extends LokasiState {
  final String message;
  LokasiErrorState(this.message);
}
