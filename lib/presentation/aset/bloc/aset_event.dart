import 'package:emas_app/data/model/request/asetRequest.dart';

abstract class AsetEvent {}

class FetchKategoriAset extends AsetEvent {}
class FetchLokasi extends AsetEvent {}
class SubmitAset extends AsetEvent {
  final AsetRequest data;
  SubmitAset(this.data);
}
class DeleteAset extends AsetEvent {
  final int asetId;
  DeleteAset(this.asetId);
}

class UpdateAset extends AsetEvent {
  final int id;
  final AsetRequest data;

  UpdateAset(this.id, this.data);
}

class FetchAllAset extends AsetEvent {}
class FetchAsetDropdown extends AsetEvent {}
class LoadAset extends AsetEvent {}