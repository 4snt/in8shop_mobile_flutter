import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/shared/models/product.dart';
import 'package:in8shop_mobile_flutter/src/shared/utils/format_price.dart';
import 'package:in8shop_mobile_flutter/src/shared/utils/truncate_text.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 📦 Imagem
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data.mainImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder.webp',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 🏷️ Nome
            Text(
              truncateText(data.name, maxLength: 20),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),

            const SizedBox(height: 4),

            // 🔖 Provider + Desconto
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    data.provider.toUpperCase(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                if (data.hasDiscount) ...[
                  const SizedBox(width: 6),
                  Text(
                    '${(data.discountValue * 100).round()}% OFF',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            // 💸 Preço
            if (data.hasDiscount) ...[
              Text(
                formatPrice(data.price),
                style: TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                formatPrice(data.price * (1 - data.discountValue)),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ] else
              Text(
                formatPrice(data.price),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
