import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/providers/AuthProvider.dart';
import '../shared/services/OrderService.dart';
import '../shared/utils/toast.dart';

class PaymentPage extends StatefulWidget {
  final int orderId;
  final double amount;
  final String paymentIntentId;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.amount,
    required this.paymentIntentId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;

  void _confirmPayment() async {
    final auth = context.read<AuthProvider>();

    setState(() => isLoading = true);

    try {
      final orderService = OrderService();
      await orderService.confirmOrder(
        orderId: widget.orderId,
        token: auth.token!,
      );

      Toast.success(context, '✅ Pedido confirmado com sucesso!');

      // Navega para a página de pedidos e limpa o histórico
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/my-orders', (route) => false);
    } catch (e) {
      Toast.error(context, e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pagamento do pedido #${widget.orderId}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Total: R\$ ${widget.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _confirmPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Text('Confirmar Pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}
