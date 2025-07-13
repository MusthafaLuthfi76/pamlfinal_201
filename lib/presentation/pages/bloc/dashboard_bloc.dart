import 'package:emas_app/data/model/response/dashboardmodel.dart';
import 'package:emas_app/data/model/response/get_all_aset_response.dart';
import 'package:emas_app/data/model/response/kategoriResponse.dart';
import 'package:emas_app/data/repository/kategori_aset_repository.dart';
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
    final asetRaw = await AsetRepository().getAll();
    final asetList = asetRaw.map((e) => Aset.fromMap(e)).toList();

    final keluargaRaw = await KeluargaRepository().getAll();
    final jumlahKeluarga = keluargaRaw.length;

    final kategoriRaw = await KategoriAsetRepository().getAll();
    final kategoriList = kategoriRaw.map((e) => KategoriAset.fromMap(e)).toList();

    // Buat Map ID -> Nama Kategori
    final kategoriMap = {
      for (var kat in kategoriList) kat.id!: kat.name ?? 'Tidak diketahui'
    };

    // Hitung statistik per kategori
    final Map<String, DashboardKategoriStat> statistik = {};

    for (final aset in asetList) {
      final kategori = kategoriMap[aset.kategoriAsetId ?? 0] ?? 'Lainnya';

      if (!statistik.containsKey(kategori)) {
        statistik[kategori] = DashboardKategoriStat(
          kategori: kategori,
          jumlah: 1,
          totalHarga: aset.harga ?? 0,
        );
      } else {
        final current = statistik[kategori]!;
        statistik[kategori] = DashboardKategoriStat(
          kategori: kategori,
          jumlah: current.jumlah + 1,
          totalHarga: current.totalHarga + (aset.harga ?? 0),
        );
      }
    }

    emit(DashboardLoaded(
      kategoriCount: statistik.map((k, v) => MapEntry(k, v.jumlah)),
      totalAsetPerKategori: statistik.map((k, v) => MapEntry(k, v.totalHarga)),
      totalHarta: statistik.values.fold(0.0, (sum, e) => sum + e.totalHarga),
      jumlahKeluarga: jumlahKeluarga, // ← gunakan data hasil getAll
      statistikKategori: statistik.values.toList(),
    ));

  } catch (e) {
    emit(DashboardError("Gagal memuat data: $e"));
  }
});
  }
}