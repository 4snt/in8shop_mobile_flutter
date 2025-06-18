import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../../src/shared/providers/AuthProvider.dart';
import '../shared/components/LoginForm.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (!auth.isAuthenticated || user == null) {
      return const LoginForm();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${user.name}'),
            Text('Email: ${user.email}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false, // 🔥 limpa toda a navegação
                  );
                }
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
