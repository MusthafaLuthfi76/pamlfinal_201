import 'package:emas_app/data/model/response/asetResponse.dart';
import 'package:emas_app/data/model/response/lokasiResponse.dart';

abstract class AsetState {}

class AsetInitial extends AsetState {}

class AsetLoading extends AsetState {}

class AsetSubmitting extends AsetState {}

class AsetSuccess extends AsetState {}

class AsetUpdated extends AsetState {}
class AsetDeleted extends AsetState {}

class AsetFailure extends AsetState {
  final String message;
  AsetFailure(this.message);
}

class AsetLoaded extends AsetState {
  final List<Map<String, dynamic>> kategori;
  final List<Lokasi> lokasi;
  

  AsetLoaded({required this.kategori, required this.lokasi});
}

class AsetListLoaded extends AsetState {
  final List aset;
  AsetListLoaded(this.aset);
}

class AsetDropdownLoaded extends AsetState {
  final List<Aset> asets;

  AsetDropdownLoaded(this.asets);
}
