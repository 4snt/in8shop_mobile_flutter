import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/shared/providers/cart_provider.dart';
import 'package:in8shop_mobile_flutter/src/shared/utils/format_price.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio.'))
          : ListView.builder(
              itemCount: cart.items.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                final product = item['product'];
                final quantity = item['quantity'];

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
                      onPressed: () {
                        cart.remove(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ação de finalizar pedido
                },
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Finalizar Pedido'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
