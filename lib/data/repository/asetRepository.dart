import 'package:emas_app/data/model/request/asetRequest.dart';
import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


class AsetRepository {
  final client = ServiceHttpClient();

  Future<List<dynamic>> getAll() async {
    final res = await client.get('aset');
    return res.statusCode == 200 ? res.jsonBody()['data'] : [];
  }

  Future<bool> createWithImage(AsetRequest data, File foto) async {
  final uri = Uri.parse("http://192.168.0.185:3000/api/aset/store");
  final request = http.MultipartRequest('POST', uri);

  request.fields['nama'] = data.nama;
  request.fields['kategori_aset_id'] = data.kategoriAsetId.toString();
  request.fields['lokasi_id'] = data.lokasiId.toString();
  request.fields['berat'] = data.berat.toString();
  request.fields['harga'] = data.harga.toString();

  // ⛳️ Upload file
  request.files.add(await http.MultipartFile.fromPath('foto', foto.path));

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  return response.statusCode == 201;
}


  Future<bool> create(AsetRequest data) async {
  final uri = Uri.parse('${client.baseUrl}aset/store');
  final request = http.MultipartRequest('POST', uri);

  request.fields['nama'] = data.nama;
  request.fields['kategori_aset_id'] = data.kategoriAsetId.toString();
  request.fields['lokasi_id'] = data.lokasiId.toString();
  request.fields['berat'] = data.berat.toString();
  request.fields['harga'] = data.harga.toString();

  if (data.foto != null && File(data.foto!).existsSync()) {
    request.files.add(await http.MultipartFile.fromPath('foto', data.foto!));
  }

  final streamed = await request.send();
  return streamed.statusCode == 201;
}

  Future<Map<String, dynamic>> getById(int id) async {
    final res = await client.get('aset/$id');
    return res.jsonBody()['data'];
  }

  Future<bool> update(int id, AsetRequest data) async {
    final res = await client.put('aset/$id', data.toJson());
    return res.statusCode == 200;
  }

  Future<bool> delete(int id) async {
  final res = await client.delete('aset/$id');
  return res.statusCode == 200;
  }
}
