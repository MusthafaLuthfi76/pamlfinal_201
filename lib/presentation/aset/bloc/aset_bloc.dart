import 'package:emas_app/data/model/response/asetResponse.dart';
import 'package:emas_app/data/model/response/lokasiResponse.dart';
import 'package:emas_app/data/repository/asetRepository.dart';
import 'package:emas_app/data/repository/kategori_aset_repository.dart';
import 'package:emas_app/data/repository/lokasiRepository.dart';
import 'package:emas_app/presentation/aset/bloc/aset_event.dart';
import 'package:emas_app/presentation/aset/bloc/aset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AsetBloc extends Bloc<AsetEvent, AsetState> {
  final kategoriRepo = KategoriAsetRepository();
  final lokasiRepo = LokasiRepository();
  final asetRepo = AsetRepository();

  AsetBloc() : super(AsetInitial()) {
    on<FetchKategoriAset>((event, emit) async {
      emit(AsetLoading());
      try {
        final kategoriRaw = await kategoriRepo.getAll();
        final lokasiRaw = await lokasiRepo.getAll();

        final kategori = kategoriRaw.cast<Map<String, dynamic>>();
        final lokasi = lokasiRaw
            .map((e) => Lokasi.fromMap(e as Map<String, dynamic>))
            .toList();

        emit(AsetLoaded(kategori: kategori, lokasi: lokasi));
      } catch (e) {
        emit(AsetFailure("Gagal memuat data: $e"));
      }
    });

    on<SubmitAset>((event, emit) async {
      emit(AsetSubmitting());
      try {
        final success = await asetRepo.create(event.data);
        if (success) {
          emit(AsetSuccess());
          add(FetchAllAset());
        } else {
          emit(AsetFailure("Gagal menyimpan aset"));
        }
      } catch (e) {
        emit(AsetFailure("Terjadi kesalahan: $e"));
      }
    });

    on<UpdateAset>((event, emit) async {
      emit(AsetSubmitting());
      try {
        final success = await asetRepo.update(event.id, event.data);
        if (success) {
          emit(AsetSuccess());
          add(FetchAllAset());
        } else {
          emit(AsetFailure("Gagal mengupdate aset"));
        }
      } catch (e) {
        emit(AsetFailure("Terjadi kesalahan: $e"));
      }
    });

    on<DeleteAset>((event, emit) async {
      emit(AsetLoading());
      try {
        final success = await asetRepo.delete(event.asetId);
        if (success) {
          add(FetchAllAset());
        } else {
          emit(AsetFailure("Gagal menghapus aset"));
        }
      } catch (e) {
        emit(AsetFailure("Terjadi kesalahan: $e"));
      }
    });

    on<FetchAllAset>((event, emit) async {
      emit(AsetLoading());
      try {
        final aset = await asetRepo.getAll();
        emit(AsetListLoaded(aset));
      } catch (e) {
        emit(AsetFailure("Gagal memuat daftar aset: $e"));
      }
    });
    on<LoadAset>((event, emit) async {
      emit(AsetLoading());
      try {
        final raw = await asetRepo.getAll();
        final list = raw.map((e) => Aset.fromMap(e)).toList();
        emit(AsetDropdownLoaded(list)); // <- pastikan emit-nya ini
      } catch (e) {
        emit(AsetFailure("Gagal memuat aset dropdown: $e"));
      }
    });

  }
}