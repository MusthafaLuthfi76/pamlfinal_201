import 'package:emas_app/data/model/request/keluargaRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class KeluargaRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('keluarga');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  // Fungsi untuk membuat data keluarga baru
  Future<bool> create(KeluargaRequest data) async {
    final res = await client.postWihToken('keluarga/store', data.toJson());
    return res.statusCode == 201; // Pastikan status code 201 (Created)
  }

  // Fungsi untuk memperbarui data keluarga
  Future<bool> update(int id, KeluargaRequest data) async {
    final res = await client.put('keluarga/$id', data.toJson());
    return res.statusCode == 200; // Pastikan status code 200 (OK)
  }

  // Fungsi untuk menghapus data keluarga
  Future<bool> delete(int id) async {
    final res = await client.delete('keluarga/$id');
    return res.statusCode == 200; // Pastikan status code 200 (OK)
  }
}