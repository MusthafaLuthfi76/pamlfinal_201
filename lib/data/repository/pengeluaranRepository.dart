import 'package:emas_app/data/model/request/pengeluaranRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class PengeluaranRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('pengeluaran');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  Future<bool> create(PengeluaranRequest data) async {
    final res = await client.postWihToken('pengeluaran/store', data.toJson());
    return res.statusCode == 201;
  }

  Future<bool> update(int id, PengeluaranRequest data) async {
    final res = await client.postWihToken('pengeluaran/update/$id', data.toJson());
    return res.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final res = await client.postWihToken('pengeluaran/delete/$id', {});
    return res.statusCode == 200;
  }
}