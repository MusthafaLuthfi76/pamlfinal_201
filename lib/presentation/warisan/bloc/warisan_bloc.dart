import 'package:emas_app/data/repository/asetRepository.dart';
import 'package:emas_app/data/repository/keluargaRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'warisan_event.dart';
import 'warisan_state.dart';
import 'package:emas_app/data/repository/warisanRepository.dart';

class WarisanBloc extends Bloc<WarisanEvent, WarisanState> {
  final WarisanRepository repository;

  WarisanBloc(this.repository) : super(WarisanInitial()) {
    on<FetchWarisan>((event, emit) async {
      emit(WarisanLoading());
      try {
        final data = await repository.getAll();
        emit(WarisanLoaded(data));
      } catch (e) {
        emit(WarisanFailure("Gagal memuat data"));
      }
    });

    on<CreateWarisan>((event, emit) async {
      emit(WarisanLoading());
      try {
        final success = await repository.create(event.request);
        if (success) {
          emit(WarisanSuccess("Data berhasil ditambahkan"));
          add(FetchWarisan());
        } else {
          emit(WarisanFailure("Gagal menyimpan data"));
        }
      } catch (_) {
        emit(WarisanFailure("Gagal koneksi ke server"));
      }
    });

    on<UpdateWarisan>((event, emit) async {
      emit(WarisanLoading());
      try {
        final success = await repository.update(event.id, event.request);
        if (success) {
          emit(WarisanSuccess("Data berhasil diperbarui"));
          add(FetchWarisan());
        } else {
          emit(WarisanFailure("Gagal memperbarui data"));
        }
      } catch (_) {
        emit(WarisanFailure("Gagal koneksi ke server"));
      }
    });

    on<DeleteWarisan>((event, emit) async {
      emit(WarisanLoading());
      try {
        final success = await repository.delete(event.id);
        if (success) {
          emit(WarisanSuccess("Data berhasil dihapus"));
          add(FetchWarisan());
        } else {
          emit(WarisanFailure("Gagal menghapus data"));
        }
      } catch (_) {
        emit(WarisanFailure("Terjadi kesalahan"));
      }
    });

    on<FetchWarisanFormData>((event, emit) async {
      emit(WarisanLoading());
      final asetRepo = AsetRepository();
      final keluargaRepo = KeluargaRepository();

      final aset = await asetRepo.getAll();
      final keluarga = await keluargaRepo.getAll();

      emit(WarisanFormDataLoaded(aset, keluarga));
    });

  }
}
