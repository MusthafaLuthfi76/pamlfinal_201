import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import 'package:emas_app/data/repository/asetRepository.dart';
import 'package:emas_app/data/repository/keluargaRepository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>((event, emit) async {
      emit(DashboardLoading());
      try {
        final asetList = await AsetRepository().getAll();
        final keluargaList = await KeluargaRepository().getAll();

        num totalHarta = 0;
        Map<String, int> kategoriCount = {};

        for (var aset in asetList) {
          final kategori = aset['kategori_nama'] ?? 'Tidak diketahui';
          final harga = aset['harga'] ?? 0;
          totalHarta += harga;
          kategoriCount[kategori] = (kategoriCount[kategori] ?? 0) + 1;
        }

        emit(DashboardLoaded(
          kategoriCount: kategoriCount,
          totalHarta: totalHarta,
          jumlahKeluarga: keluargaList.length,
        ));
      } catch (_) {
        emit(DashboardError("Gagal memuat data"));
      }
    });
  }
}