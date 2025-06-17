import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/shared/utils/format_price.dart';

class CartItem extends StatelessWidget {
  final dynamic product;
  final int quantity;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.mainImage,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/placeholder.webp',
                width: 56,
                height: 56,
              );
            },
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          'Qtd: $quantity\n${formatPrice(product.price * (1 - product.discountValue))}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
