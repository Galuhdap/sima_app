import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://172.16.100.60:8000/api';

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/data'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data');
    }
  }
}
