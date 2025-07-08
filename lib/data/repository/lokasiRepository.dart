import 'package:emas_app/data/model/request/lokasiRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class LokasiRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('lokasi');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  Future<bool> create(LokasiRequest data) async {
    final res = await client.postWihToken('lokasi/store', data.toJson());
    return res.statusCode == 201;
  }

  Future<bool> update(int id, LokasiRequest data) async {
    final res = await client.postWihToken('lokasi/update/$id', data.toJson());
    return res.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final res = await client.postWihToken('lokasi/delete/$id', {});
    return res.statusCode == 200;
  }
}