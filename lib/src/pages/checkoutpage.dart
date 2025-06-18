import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/pages/PaymentPage.dart';
import 'package:provider/provider.dart';

import '../shared/providers/AuthProvider.dart';
import '../shared/providers/cart_provider.dart';
import '../shared/services/OrderService.dart';
import '../shared/utils/toast.dart';
import '../shared/widgets/cartitem.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  String line1 = '';
  String line2 = '';
  String city = '';
  String stateField = '';
  String zip = '';
  String country = 'Brasil';

  bool isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final token = auth.token!;

    setState(() => isLoading = true);

    try {
      final orderService = OrderService();

      final response = await orderService.placeOrder(
        userId: auth.user!.id,
        amount: cart.cartTotalAmount,
        currency: 'BRL',
        products: cart.items
            .map(
              (item) => {
                'name': item['product'].name,
                'quantity': item['quantity'],
                'price': item['product'].price,
              },
            )
            .toList(),
        address: {
          'line1': line1,
          'line2': line2,
          'city': city,
          'state': stateField,
          'zip': zip,
          'country': country,
        },
        token: token,
      );

      Toast.show(
        context,
        message: 'Pedido criado com sucesso!',
        background: Colors.green,
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );

      // ⚡ Navegar para tela de pagamento (iremos criar depois)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            orderId: int.tryParse(response['id'].toString()) ?? 0,
            amount: response['amount'] is String
                ? double.tryParse(response['amount']) ?? 0.0
                : (response['amount'] as num).toDouble(),
            paymentIntentId: response['paymentIntentId'].toString(),
          ),
        ),
      );

      cart.clear();
    } catch (e) {
      Toast.show(
        context,
        message: e.toString().replaceAll('Exception: ', ''),
        background: Colors.red,
        textColor: Colors.white,
        icon: Icons.error_outline,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Itens do Pedido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...cart.items.map((item) {
                final product = item['product'];
                final quantity = item['quantity'];

                return CartItem(
                  product: product,
                  quantity: quantity,
                  onRemove: () {},
                );
              }),

              const SizedBox(height: 24),
              const Text(
                'Endereço de Entrega',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                label: 'Endereço (linha 1)',
                onSaved: (v) => line1 = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o endereço' : null,
              ),
              _buildTextField(
                label: 'Complemento (linha 2)',
                onSaved: (v) => line2 = v ?? '',
                required: false,
              ),
              _buildTextField(
                label: 'Cidade',
                onSaved: (v) => city = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a cidade' : null,
              ),
              _buildTextField(
                label: 'Estado',
                onSaved: (v) => stateField = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o estado' : null,
              ),
              _buildTextField(
                label: 'CEP',
                onSaved: (v) => zip = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o CEP' : null,
              ),
              _buildTextField(
                label: 'País',
                initialValue: 'Brasil',
                onSaved: (v) => country = v ?? '',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o país' : null,
              ),

              const SizedBox(height: 20),
              Text(
                'Total: R\$ ${cart.cartTotalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text('Finalizar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    bool required = true,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
        onSaved: onSaved,
        validator:
            validator ??
            (required
                ? (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null
                : null),
      ),
    );
  }
}
