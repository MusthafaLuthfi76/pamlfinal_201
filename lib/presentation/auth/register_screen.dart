import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emas_app/presentation/auth/bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'anak';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/login');
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
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                DropdownButton<String>(
                  value: role,
                  items: ['admin', 'anak']
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => role = value!),
                ),
                SizedBox(height: 16),
                state is AuthLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                RegisterRequested(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  role: role,
                                ),
                              );
                        },
                        child: Text('Register'),
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}