import 'package:emas_app/data/model/request/warisanRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class WarisanRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('warisan');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  Future<bool> create(WarisanRequest data) async {
    final res = await client.postWihToken('warisan/store', data.toJson());
    return res.statusCode == 201;
  }

  Future<bool> update(int id, WarisanRequest data) async {
    final res = await client.postWihToken('warisan/update/$id', data.toJson());
    return res.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final res = await client.postWihToken('warisan/delete/$id', {});
    return res.statusCode == 200;
  }
}