import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/modules/product/models/product.dart';
import 'package:in8shop_mobile_flutter/src/shared/providers/cart_provider.dart';
import 'package:in8shop_mobile_flutter/src/shared/utils/format_price.dart';
import 'package:provider/provider.dart';

class ProductPageItem extends StatefulWidget {
  final Product product;

  const ProductPageItem({super.key, required this.product});

  @override
  State<ProductPageItem> createState() => _ProductPageItemState();
}

class _ProductPageItemState extends State<ProductPageItem> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final hasDiscount = widget.product.hasDiscount;
    final discountedPrice =
        widget.product.price * (1 - widget.product.discountValue);

    final isInCart = cart.isInCart(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 📦 Imagem com fallback
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.product.images.isNotEmpty
                      ? widget.product.images.first
                      : '',
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

            const SizedBox(height: 16),

            // 🏷️ Nome
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            // 🔖 Provider
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Text(
                widget.product.provider.toUpperCase(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 16),

            // 💸 Preços
            if (hasDiscount) ...[
              Text(
                'De: ${formatPrice(widget.product.price)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Por: ${formatPrice(discountedPrice)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
              Text(
                formatPrice(widget.product.price),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 24),

            // 🔢 Seletor de quantidade
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🛒 Botões
            Column(
              children: [
                // Botão de adicionar
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      cart.add(widget.product, quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adicionado ao carrinho')),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Adicionar ao Carrinho'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Se já estiver no carrinho → botão remover
                if (isInCart)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        cart.remove(widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removido do carrinho')),
                        );
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remover do Carrinho'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
