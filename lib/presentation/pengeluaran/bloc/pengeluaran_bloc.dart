import 'package:bloc/bloc.dart';
import 'package:emas_app/data/model/response/pengeluaranResponse.dart';
import 'package:emas_app/data/repository/pengeluaranRepository.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:emas_app/presentation/pengeluaran/bloc/pengeluaran_state.dart';
import 'package:equatable/equatable.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  final PengeluaranRepository repository;

  PengeluaranBloc(this.repository) : super(PengeluaranInitial()) {
    on<LoadPengeluaran>((event, emit) async {
      emit(PengeluaranLoading());
      try {
        final result = await repository.getAll(); // FIXED
        emit(PengeluaranLoaded(result)); // FIXED
      } catch (e) {
        emit(PengeluaranError("Gagal memuat data pengeluaran: $e"));
      }
    });

    on<CreatePengeluaran>((event, emit) async {
      emit(PengeluaranLoading());
      final success = await repository.create(event.request);
      if (success) {
        add(LoadPengeluaran());
      } else {
        emit(PengeluaranError("Gagal menambahkan pengeluaran"));
      }
    });

    on<UpdatePengeluaran>((event, emit) async {
      emit(PengeluaranLoading());
      final success = await repository.update(event.id, event.request);
      if (success) {
        add(LoadPengeluaran());
      } else {
        emit(PengeluaranError("Gagal memperbarui pengeluaran"));
      }
    });

    on<DeletePengeluaran>((event, emit) async {
      emit(PengeluaranLoading());
      final success = await repository.delete(event.id);
      if (success) {
        add(LoadPengeluaran());
      } else {
        emit(PengeluaranError("Gagal menghapus pengeluaran"));
      }
    });
  }
}