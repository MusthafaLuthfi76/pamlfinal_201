import 'package:emas_app/data/repository/kategoriKeluargaRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'kategori_keluarga_event.dart';
part 'kategori_keluarga_state.dart';

class KategoriKeluargaBloc extends Bloc<KategoriKeluargaEvent, KategoriKeluargaState> {
  final KategoriKeluargaRepository kategoriKeluargaRepository;

  KategoriKeluargaBloc(this.kategoriKeluargaRepository)
      : super(KategoriKeluargaInitial()) {
    on<FetchKategoriKeluargaEvent>(_onFetchKategoriKeluarga);
  }

  Future<void> _onFetchKategoriKeluarga(
      FetchKategoriKeluargaEvent event, Emitter<KategoriKeluargaState> emit) async {
    emit(KategoriKeluargaLoadingState());
    try {
      final kategoriKeluargaList = await kategoriKeluargaRepository.getAll();
      emit(KategoriKeluargaLoadedState(kategoriKeluargaList));
    } catch (e) {
      emit(KategoriKeluargaErrorState(e.toString()));
    }
  }
}
