import 'package:intl/intl.dart';

String formatPrice(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_US', // Mesma que você usava no React
    symbol: '\$', // Ou 'USD' se quiser
  );
  return formatter.format(amount);
}
