abstract class WarisanState {}

class WarisanInitial extends WarisanState {}

class WarisanLoading extends WarisanState {}

class WarisanLoaded extends WarisanState {
  final List<dynamic> data;
  WarisanLoaded(this.data);
}

class WarisanSuccess extends WarisanState {
  final String message;
  WarisanSuccess(this.message);
}

class WarisanFailure extends WarisanState {
  final String message;
  WarisanFailure(this.message);
}

class WarisanFormDataLoaded extends WarisanState {
  final List<dynamic> asetList;
  final List<dynamic> keluargaList;
  WarisanFormDataLoaded(this.asetList, this.keluargaList);
}
