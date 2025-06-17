import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in8shop_mobile_flutter/src/shared/models/product.dart';

class ProductsService {
  final dio = Dio();
  final baseUrl = dotenv.env['API_URL'];

  ProductsService();

  // 🔥 Guarda os últimos filtros aplicados
  String? lastQuery;
  String? lastProvider;
  String? lastCategory;
  bool? lastHasDiscount;
  double? lastMinPrice;
  double? lastMaxPrice;

  Future<List<Product>> getProducts({
    String? query,
    String? provider,
    String? category,
    bool? hasDiscount,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final url = '$baseUrl/api/products';

      final params = {
        if (query != null && query.isNotEmpty) 'query': query,
        if (provider != null && provider.isNotEmpty) 'provider': provider,
        if (category != null && category.isNotEmpty) 'category': category,
        if (hasDiscount != null) 'hasDiscount': hasDiscount.toString(),
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      };

      // 🧠 Atualiza os filtros atuais
      lastQuery = query;
      lastProvider = provider;
      lastCategory = category;
      lastHasDiscount = hasDiscount;
      lastMinPrice = minPrice;
      lastMaxPrice = maxPrice;

      print('➡️ Chamando $url com filtros $params');

      final response = await dio.get(url, queryParameters: params);

      final data = response.data as List;
      return data.map((item) => Product.fromMap(item)).toList();
    } catch (e) {
      print('❌ Erro na requisição: $e');
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  // 🔄 Método opcional para limpar os filtros atuais
  void clearLastFilters() {
    lastQuery = null;
    lastProvider = null;
    lastCategory = null;
    lastHasDiscount = null;
    lastMinPrice = null;
    lastMaxPrice = null;
  }
}
