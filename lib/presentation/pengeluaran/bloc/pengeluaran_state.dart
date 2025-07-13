abstract class PengeluaranState {}

class PengeluaranInitial extends PengeluaranState {}

class PengeluaranLoading extends PengeluaranState {}

class PengeluaranLoaded extends PengeluaranState {
  final List<dynamic> pengeluaranList;
  PengeluaranLoaded(this.pengeluaranList);
}

class PengeluaranSuccess extends PengeluaranState {}

class PengeluaranError extends PengeluaranState {
  final String message;
  PengeluaranError(this.message);
}
