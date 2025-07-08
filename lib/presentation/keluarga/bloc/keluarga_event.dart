part of 'keluarga_bloc.dart';


abstract class KeluargaEvent {}

class FetchKeluargaEvent extends KeluargaEvent {}

class CreateKeluargaEvent extends KeluargaEvent {
  final KeluargaRequest keluargaRequest;
  CreateKeluargaEvent(this.keluargaRequest);
}

class UpdateKeluargaEvent extends KeluargaEvent {
  final int id;
  final KeluargaRequest keluargaRequest;
  UpdateKeluargaEvent(this.id, this.keluargaRequest);
}

class DeleteKeluargaEvent extends KeluargaEvent {
  final int id;
  DeleteKeluargaEvent(this.id);
}
