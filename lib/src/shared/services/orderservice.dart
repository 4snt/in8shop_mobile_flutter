import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderService {
  final Dio dio = Dio();
  final String baseUrl = dotenv.env['API_URL']!;

  OrderService();

  /// 🚀 Cria um pedido
  Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required double amount,
    required String currency,
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> address,
    required String token,
  }) async {
    try {
      final res = await dio.post(
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
          'paymentIntentId': DateTime.now().millisecondsSinceEpoch
              .toString(), // Pode ser UUID se preferir
          'products': products,
          'address': address,
        },
      );

      return res.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Erro ao criar pedido';
      throw Exception(errorMessage);
    }
  }

  Future<void> confirmOrder({
    required int orderId,
    required String token,
  }) async {
    try {
      final res = await dio.post(
        '$baseUrl/api/orders/${orderId.toString()}/payment', // 👈 converte aqui
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? 'Erro ao confirmar pagamento');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ??
          e.message ??
          'Erro ao confirmar pagamento';
      throw Exception(errorMessage);
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrders({
    required String token,
  }) async {
    try {
      final res = await dio.get(
        '$baseUrl/api/orders',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode != 200) {
        throw Exception(res.data['message'] ?? 'Erro ao buscar pedidos');
      }

      return List<Map<String, dynamic>>.from(res.data);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Erro ao buscar pedidos';
      throw Exception(errorMessage);
    }
  }
}
