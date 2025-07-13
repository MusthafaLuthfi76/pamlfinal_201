import 'package:emas_app/data/model/response/dashboardmodel.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final Map<String, int> kategoriCount;
  final Map<String, double> totalAsetPerKategori; // ← Tambahkan ini
  final double totalHarta;
  final int jumlahKeluarga;
  final List<DashboardKategoriStat> statistikKategori;

  DashboardLoaded({
    required this.kategoriCount,
    required this.totalAsetPerKategori,
    required this.totalHarta,
    required this.jumlahKeluarga,
    required this.statistikKategori,
  });
}


class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
