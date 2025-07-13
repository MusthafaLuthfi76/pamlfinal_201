import 'package:emas_app/data/model/request/warisanRequest.dart';

abstract class WarisanEvent {}

class FetchWarisan extends WarisanEvent {}

class CreateWarisan extends WarisanEvent {
  final WarisanRequest request;
  CreateWarisan(this.request);
}

class UpdateWarisan extends WarisanEvent {
  final int id;
  final WarisanRequest request;
  UpdateWarisan(this.id, this.request);
}

class DeleteWarisan extends WarisanEvent {
  final int id;
  DeleteWarisan(this.id);
}
class FetchWarisanFormData extends WarisanEvent {}
