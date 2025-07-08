import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/data/model/request/lokasiRequest.dart';
import 'package:emas_app/data/model/response/lokasiResponse.dart';
import 'package:emas_app/data/repository/lokasiRepository.dart';

part 'lokasi_event.dart';
part 'lokasi_state.dart';

class LokasiBloc extends Bloc<LokasiEvent, LokasiState> {
  final LokasiRepository lokasiRepository;

  LokasiBloc(this.lokasiRepository) : super(LokasiInitial()) {
    on<FetchLokasiEvent>(_onFetchLokasi);
    on<CreateLokasiEvent>(_onCreateLokasi);
    on<UpdateLokasiEvent>(_onUpdateLokasi);
    on<DeleteLokasiEvent>(_onDeleteLokasi);
  }

  Future<void> _onFetchLokasi(FetchLokasiEvent event, Emitter<LokasiState> emit) async {
    emit(LokasiLoadingState());
    try {
      final lokasiList = await lokasiRepository.getAll();
      emit(LokasiLoadedState(lokasiList.map((data) => Lokasi.fromMap(data)).toList()));
    } catch (e) {
      emit(LokasiErrorState(e.toString()));
    }
  }

  Future<void> _onCreateLokasi(CreateLokasiEvent event, Emitter<LokasiState> emit) async {
    emit(LokasiLoadingState());
    try {
      await lokasiRepository.create(event.lokasiRequest);
      add(FetchLokasiEvent());  // Refresh data setelah create
    } catch (e) {
      emit(LokasiErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateLokasi(UpdateLokasiEvent event, Emitter<LokasiState> emit) async {
    emit(LokasiLoadingState());
    try {
      await lokasiRepository.update(event.id, event.lokasiRequest);
      add(FetchLokasiEvent());  // Refresh data setelah update
    } catch (e) {
      emit(LokasiErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteLokasi(DeleteLokasiEvent event, Emitter<LokasiState> emit) async {
    emit(LokasiLoadingState());
    try {
      await lokasiRepository.delete(event.id);
      add(FetchLokasiEvent());  // Refresh data setelah delete
    } catch (e) {
      emit(LokasiErrorState(e.toString()));
    }
  }
}
