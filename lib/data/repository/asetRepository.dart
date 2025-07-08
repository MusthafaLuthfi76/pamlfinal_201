import 'package:emas_app/data/model/request/asetRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class AsetRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('aset');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  Future<bool> create(AsetRequest data) async {
    final res = await client.postWihToken('aset/store', data.toJson());
    return res.statusCode == 201;
  }

  Future<Map<String, dynamic>> getById(int id) async {
    final res = await client.get('aset/$id');
    return res.jsonBody()['data'];
  }

  Future<bool> update(int id, AsetRequest data) async {
    final res = await client.postWihToken('aset/update/$id', data.toJson());
    return res.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final res = await client.postWihToken('aset/delete/$id', {});
    return res.statusCode == 200;
  }
}
