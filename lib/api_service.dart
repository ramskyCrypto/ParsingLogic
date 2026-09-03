import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class ApiService {
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com/users';

  Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData
          .map((json) => UserModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Gagal mengambil data pengguna');
    }
  }
}