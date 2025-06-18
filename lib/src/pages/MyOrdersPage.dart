import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/providers/AuthProvider.dart';
import '../shared/services/OrderService.dart';
import '../shared/utils/format_price.dart';
import '../shared/utils/toast.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final auth = context.read<AuthProvider>();

    try {
      final fetchedOrders = await OrderService().fetchOrders(
        token: auth.token!,
      );
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      Toast.show(
        context,
        message: e.toString().replaceAll('Exception: ', ''),
        background: Colors.red,
        textColor: Colors.white,
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pedidos')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text('Você ainda não fez pedidos.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final order = orders[index];

                // 🔥 Corrige status
                final status = (order['status'] ?? '').toString().toLowerCase();
                final isConfirmed =
                    status == 'confirmed' || status == 'confirmada';
                final isPending = status == 'pending' || status == 'pendente';

                // 🔥 Corrige amount seguro
                final amount = (order['amount'] as num).toDouble();

                return Card(
                  child: ListTile(
                    title: Text(
                      'Pedido #${order['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data: ${DateTime.parse(order['createDate']).toLocal().toString().split(' ')[0]}',
                        ),
                        Text('Total: ${formatPrice(amount)}'),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${order['status']}',
                          style: TextStyle(
                            color: isConfirmed
                                ? Colors.green
                                : isPending
                                ? Colors.orange
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed('/order-detail', arguments: order);
                    },
                  ),
                );
              },
            ),
    );
  }
}
