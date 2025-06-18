import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/shared/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  CartProvider() {
    _loadCartFromPrefs();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item['product'].id == productId);
  }

  void add(Product product, int quantity) {
    if (!isInCart(product.id)) {
      _items.add({'product': product, 'quantity': quantity});
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  void remove(String productId) {
    _items.removeWhere((item) => item['product'].id == productId);
    _saveCartToPrefs();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  /// 🔥 Persistência local
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((item) {
      return {'product': item['product'].toMap(), 'quantity': item['quantity']};
    }).toList();

    prefs.setString('cart', jsonEncode(cartData));
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');

    if (cartString != null) {
      final List decoded = jsonDecode(cartString);
      _items.clear();
      for (var item in decoded) {
        _items.add({
          'product': Product.fromMap(item['product']),
          'quantity': item['quantity'],
        });
      }
      notifyListeners();
    }
  }

  double get cartTotalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item['product'].price * item['quantity'];
    }
    return total;
  }

  int get cartTotalItems {
    int total = 0;
    for (var item in _items) {
      total += item['quantity'] as int;
    }
    return total;
  }
}
