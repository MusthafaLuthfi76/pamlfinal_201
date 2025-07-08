import 'package:emas_app/data/model/request/kategorikeluargaRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class KategoriKeluargaRepository {
  final client = ServiceHttpClient();

  // Mengonversi data ke List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await client.get('kategori-keluarga');
    return res.statusCode == 200 ? List<Map<String, dynamic>>.from(res.jsonBody()['data']) : [];
  }


  Future<bool> create(KategoriKeluargaRequest data) async {
    final res = await client.postWihToken(
      'kategori-keluarga/store',
      data.toJson(),
    );
    return res.statusCode == 201;
  }

  Future<bool> update(int id, KategoriKeluargaRequest data) async {
  final res = await client.put(
    'kategori-keluarga/$id', // <== pakai PUT ke /:id
    data.toJson(),
  );
  return res.statusCode == 200;
}

Future<bool> delete(int id) async {
  final res = await client.delete('kategori-keluarga/$id'); // <== pakai DELETE ke /:id
  return res.statusCode == 200;
}
}
