import 'package:emas_app/data/model/request/pengeluaranRequest.dart';
import 'package:emas_app/data/model/response/pengeluaranResponse.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class PengeluaranRepository {
  final client = ServiceHttpClient();

  // Ambil semua data pengeluaran dari server
  Future<List<Pengeluaran>> getAll() async {
    final res = await client.get('pengeluaran');
    if (res.statusCode == 200) {
      final data = res.jsonBody()['data'] as List<dynamic>;
      return data.map((e) => Pengeluaran.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  // Simpan data pengeluaran
  Future<bool> create(PengeluaranRequest data) async {
    final res = await client.postWihToken('pengeluaran/store', data.toMap());
    return res.statusCode == 201;
  }

  // Perbarui data pengeluaran
  Future<bool> update(int id, PengeluaranRequest data) async {
    final res = await client.postWihToken('pengeluaran/update/$id', data.toMap());
    return res.statusCode == 200;
  }

  // Hapus data pengeluaran
  Future<bool> delete(int id) async {
    final res = await client.postWihToken('pengeluaran/delete/$id', {});
    return res.statusCode == 200;
  }
}