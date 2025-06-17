import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src/shared/providers/AuthProvider.dart';
import '../shared/components/LoginForm.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isAuthenticated) {
      return const LoginForm();
    }

    final user = auth.user ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${user['name'] ?? ''}'),
            Text('Email: ${user['email'] ?? ''}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.logout();
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
