import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String provider;
  final double price;
  final bool hasDiscount;
  final double discountValue;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.provider,
    required this.price,
    required this.hasDiscount,
    required this.discountValue,
    required this.images,
  });

  /// 🔥 Retorna a URL da imagem principal ou placeholder (como string)
  String get mainImage =>
      images.isNotEmpty ? images.first : ''; // vazio, se não tiver imagem

  /// 🔥 Retorna um ImageProvider pronto pra usar
  ImageProvider get imageProvider {
    if (images.isNotEmpty) {
      return NetworkImage(images.first);
    } else {
      return const AssetImage('assets/images/placeholder.webp');
    }
  }

  /// 🔄 Factory pra criar a partir de Map (API)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      provider: map['provider'] ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] as num).toDouble(),
      hasDiscount: map['hasDiscount'] ?? false,
      discountValue: (map['discountValue'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
    );
  }
}
