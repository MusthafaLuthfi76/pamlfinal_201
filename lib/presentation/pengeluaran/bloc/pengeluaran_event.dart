import 'package:emas_app/data/model/request/pengeluaranRequest.dart';

abstract class PengeluaranEvent {}

class LoadPengeluaran extends PengeluaranEvent {}

class CreatePengeluaran extends PengeluaranEvent {
  final PengeluaranRequest request;
  CreatePengeluaran(this.request);
}

class UpdatePengeluaran extends PengeluaranEvent {
  final int id;
  final PengeluaranRequest request;
  UpdatePengeluaran(this.id, this.request);
}

class DeletePengeluaran extends PengeluaranEvent {
  final int id;
  DeletePengeluaran(this.id);
}
