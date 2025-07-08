import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ServiceHttpClient {
  final String baseUrl = kIsWeb
    ? 'http://localhost:3000/api/'  // untuk Flutter Web
    : 'http://10.0.2.2:3000/api/'; // untuk Android emulator
  final secureStorage = FlutterSecureStorage();

  Future<http.Response> post(String endPoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endPoint");

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    _log("POST", url, body, response);
    return response;
  }

  Future<http.Response> get(String endPoint) async {
    final token = await secureStorage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endPoint");

    final response = await http.get(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _log("GET", url, null, response);
    return response;
  }

  Future<http.Response> postWihToken(String endPoint, Map<String, dynamic> body) async {
    final token = await secureStorage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endPoint");

    final response = await http.post(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    _log("POST", url, body, response);
    return response;
  }
  Future<http.Response> delete(String endPoint) async {
  final token = await secureStorage.read(key: "authToken");
  final url = Uri.parse("$baseUrl$endPoint");

  final response = await http.delete(
    url,
    headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  _log("DELETE", url, null, response);
  return response;
}

Future<http.Response> put(String endPoint, Map<String, dynamic> body) async {
  final token = await secureStorage.read(key: "authToken");
  final url = Uri.parse("$baseUrl$endPoint");

  final response = await http.put(
    url,
    headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  _log("PUT", url, body, response);
  return response;
}


  void _log(String method, Uri url, Map<String, dynamic>? body, http.Response response) {
    log("==== HTTP REQUEST ====");
    log("Method: $method");
    log("URL: $url");
    if (body != null) log("Body: ${jsonEncode(body)}");
    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    log("======================");
  }

  
}
