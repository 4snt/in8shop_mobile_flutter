import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio = Dio();
  final String baseUrl = dotenv.env['API_URL']!;

  AuthService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/api/auth/login',
        data: {'email': email, 'password': password},
      );

      return res.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Erro ao fazer login';
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/api/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      return res.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Erro ao registrar';
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getCurrentUser({required String token}) async {
    try {
      final res = await dio.get(
        '$baseUrl/api/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return res.data;
    } on DioException {
      return {};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }
}
