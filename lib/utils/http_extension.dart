import 'dart:convert';
import 'package:http/http.dart' as http;

extension JsonBodyExtension on http.Response {
  Map<String, dynamic> jsonBody() {
    try {
      return jsonDecode(body);
    } catch (e) {
      throw Exception("Gagal decode JSON: $e\nBody: $body");
    }
  }
}
