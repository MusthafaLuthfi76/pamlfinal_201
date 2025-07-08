import 'package:emas_app/services/service_http_client.dart';
import 'package:emas_app/utils/http_extension.dart';

class DashboardRepository {
  final client = ServiceHttpClient();

  Future<Map<String, dynamic>> getTotalAset() async {
    final res = await client.get('dashboard/total-aset');
    return res.statusCode == 200 ? res.jsonBody()['data'] : {};
  }

  Future<Map<String, dynamic>> getTotalHarta() async {
    final res = await client.get('dashboard/total-harta');
    return res.statusCode == 200 ? res.jsonBody()['data'] : {};
  }

  Future<Map<String, dynamic>> getTotalKeluarga() async {
    final res = await client.get('dashboard/total-keluarga');
    return res.statusCode == 200 ? res.jsonBody()['data'] : {};
  }
}
