// Lokasi: lib/data/repository/kategori_aset_repository.dart

import 'package:emas_app/data/model/request/kategoriRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class KategoriAsetRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('kategori-aset');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  Future<bool> create(KategoriRequest data) async {
    final res = await client.postWihToken('kategori-aset/store', data.toJson());
    return res.statusCode == 201;
  }

  Future<bool> update(int id, KategoriRequest data) async {
  final res = await client.put('kategori-aset/$id', data.toJson());
  return res.statusCode == 200;
}


  Future<bool> delete(int id) async {
  final res = await client.delete('kategori-aset/$id');
  return res.statusCode == 200;
}
}
