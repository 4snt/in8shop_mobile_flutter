import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  bool isInCart(String productId) {
    return _items.any((item) => item['product'].id == productId);
  }

  void add(Product product, int quantity) {
    if (!isInCart(product.id)) {
      _items.add({'product': product, 'quantity': quantity});
      notifyListeners();
    }
  }

  void remove(String productId) {
    _items.removeWhere((item) => item['product'].id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
