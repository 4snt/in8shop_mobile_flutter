import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/pages/loginpage.dart';
import 'package:in8shop_mobile_flutter/src/shared/providers/AuthProvider.dart';
import 'package:in8shop_mobile_flutter/src/shared/providers/cart_provider.dart';
import 'package:in8shop_mobile_flutter/src/shared/widgets/cartitem.dart';
import 'package:provider/provider.dart';

import './checkoutpage.dart';

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
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Limpar Carrinho',
              onPressed: () {
                cart.clear();
              },
            ),
        ],
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

                return CartItem(
                  product: product,
                  quantity: quantity,
                  onRemove: () => cart.remove(product.id),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${cart.cartTotalItems} itens',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        'Total: R\$ ${cart.cartTotalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            cart.clear();
                          },
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text('Limpar Carrinho'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final auth = context.read<AuthProvider>();

                            if (!auth.isAuthenticated) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CheckoutPage(),
                              ),
                            );
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
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
