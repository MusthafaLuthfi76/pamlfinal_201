part of 'lokasi_bloc.dart';

abstract class LokasiEvent {}

class FetchLokasiEvent extends LokasiEvent {}

class CreateLokasiEvent extends LokasiEvent {
  final LokasiRequest lokasiRequest;
  CreateLokasiEvent(this.lokasiRequest);
}

class UpdateLokasiEvent extends LokasiEvent {
  final int id;
  final LokasiRequest lokasiRequest;
  UpdateLokasiEvent(this.id, this.lokasiRequest);
}

class DeleteLokasiEvent extends LokasiEvent {
  final int id;
  DeleteLokasiEvent(this.id);
}
