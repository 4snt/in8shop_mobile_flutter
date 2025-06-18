import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in8shop_mobile_flutter/src/pages/CartPage.dart';
import 'package:in8shop_mobile_flutter/src/pages/MyOrdersPage.dart';
import 'package:in8shop_mobile_flutter/src/pages/checkoutpage.dart';
import 'package:in8shop_mobile_flutter/src/pages/loginpage.dart';
import 'package:in8shop_mobile_flutter/src/pages/register_page.dart';
import 'package:in8shop_mobile_flutter/src/pages/userpage.dart';
import 'package:provider/provider.dart';

import 'src/pages/home_page.dart';
import 'src/shared/providers/AuthProvider.dart';
import 'src/shared/providers/cart_provider.dart';
import 'src/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadAuth()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'In8Shop Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/home', // 🔥 Define qual tela começa
        routes: {
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/cart': (context) => const CartPage(),
          '/checkout': (context) => const CheckoutPage(),
          '/profile': (context) => const UserPage(),
          '/my-orders': (context) => const MyOrdersPage(),
        },
      ),
    );
  }
}
