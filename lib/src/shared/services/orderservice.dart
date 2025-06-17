import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final Dio dio = Dio();
  final String baseUrl = dotenv.env['API_URL']!;

  OrderService();

  Future<Map<String, dynamic>> placeOrder({
    required String token,
    required int userId,
    required double amount,
    required String currency,
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> address,
  }) async {
    final paymentIntentId = const Uuid().v4();

    try {
      final response = await dio.post(
        '$baseUrl/api/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'userId': userId,
          'amount': amount,
          'currency': currency,
          'paymentIntentId': paymentIntentId,
          'products': products,
          'address': address,
        },
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Erro ao criar pedido';
      throw Exception(errorMessage);
    }
  }
}
