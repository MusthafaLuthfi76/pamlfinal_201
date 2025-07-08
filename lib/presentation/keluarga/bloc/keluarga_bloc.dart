import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/data/repository/keluargaRepository.dart';
import 'package:emas_app/data/model/request/keluargaRequest.dart';
import 'package:emas_app/data/model/response/keluargaResponse.dart';

part 'keluarga_event.dart';
part 'keluarga_state.dart';

class KeluargaBloc extends Bloc<KeluargaEvent, KeluargaState> {
  final KeluargaRepository keluargaRepository;

  KeluargaBloc(this.keluargaRepository) : super(KeluargaInitial()) {
    on<FetchKeluargaEvent>(_onFetchKeluarga);
    on<CreateKeluargaEvent>(_onCreateKeluarga);
    on<UpdateKeluargaEvent>(_onUpdateKeluarga);
    on<DeleteKeluargaEvent>(_onDeleteKeluarga);
  }

  Future<void> _onFetchKeluarga(FetchKeluargaEvent event, Emitter<KeluargaState> emit) async {
    emit(KeluargaLoadingState());
    try {
      final keluargaList = await keluargaRepository.getAll();
      emit(KeluargaLoadedState(keluargaList.map((data) => Keluarga.fromMap(data)).toList()));
    } catch (e) {
      emit(KeluargaErrorState(e.toString()));
    }
  }

  Future<void> _onCreateKeluarga(CreateKeluargaEvent event, Emitter<KeluargaState> emit) async {
    emit(KeluargaLoadingState());
    try {
      await keluargaRepository.create(event.keluargaRequest);
      add(FetchKeluargaEvent()); // Refresh list after creation
    } catch (e) {
      emit(KeluargaErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateKeluarga(UpdateKeluargaEvent event, Emitter<KeluargaState> emit) async {
    emit(KeluargaLoadingState());
    try {
      await keluargaRepository.update(event.id, event.keluargaRequest);
      add(FetchKeluargaEvent()); // Refresh list after update
    } catch (e) {
      emit(KeluargaErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteKeluarga(DeleteKeluargaEvent event, Emitter<KeluargaState> emit) async {
    emit(KeluargaLoadingState());
    try {
      await keluargaRepository.delete(event.id);
      add(FetchKeluargaEvent()); // Refresh list after delete
    } catch (e) {
      emit(KeluargaErrorState(e.toString()));
    }
  }
}
