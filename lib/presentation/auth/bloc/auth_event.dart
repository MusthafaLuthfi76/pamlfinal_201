part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String name;
  final String password;

  LoginRequested({required this.name, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}