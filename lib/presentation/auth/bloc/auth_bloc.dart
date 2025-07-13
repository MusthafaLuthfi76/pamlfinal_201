import 'package:bloc/bloc.dart';
import 'package:emas_app/data/model/request/auth/loginRequest.dart';
import 'package:emas_app/data/model/request/auth/registerRequest.dart';
import 'package:emas_app/data/repository/authRepository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await authRepository.login(
          LoginRequest(name: event.name, password: event.password),
        );
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.register(
          RegisterRequest(
            name: event.name,
            email: event.email,
            password: event.password,
            role: event.role,
          ),
        );
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });
  }
}
