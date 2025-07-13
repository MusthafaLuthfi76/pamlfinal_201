abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Map<String, int> kategoriCount;
  final num totalHarta;
  final int jumlahKeluarga;

  DashboardLoaded({
    required this.kategoriCount,
    required this.totalHarta,
    required this.jumlahKeluarga,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
