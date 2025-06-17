import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'src/pages/home_page.dart';
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
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        title: 'In8Shop Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // 🌞 Tema claro
        darkTheme: AppTheme.darkTheme, // 🌚 Tema escuro
        themeMode: ThemeMode.system, // 🔥 Alterna automático com o sistema
        home: const HomePage(),
      ),
    );
  }
}
