import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                state is AuthLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                LoginRequested(
                                  name: usernameController.text,
                                  password: passwordController.text,
                                ),
                              );
                        },
                        child: Text('Login'),
                      ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text("Belum punya akun? Register"),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}