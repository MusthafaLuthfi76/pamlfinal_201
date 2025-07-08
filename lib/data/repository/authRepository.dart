import 'package:emas_app/data/model/request/auth/loginRequest.dart';
import 'package:emas_app/data/model/request/auth/registerRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class AuthRepository {
  final client = ServiceHttpClient();

  Future<Map<String, dynamic>> login(LoginRequest data) async {
    final res = await client.post('users/login', data.toJson());
    return res.statusCode == 200 ? res.jsonBody() : throw Exception("Login gagal");
  }

  Future<bool> register(RegisterRequest data) async {
    final res = await client.post('users/register', data.toJson());
    return res.statusCode == 201;
  }
}