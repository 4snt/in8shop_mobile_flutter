import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/shared/providers/AuthProvider.dart';
import 'package:in8shop_mobile_flutter/src/shared/widgets/FormWrap.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: FormWrap(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Entrar na conta',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value ?? '',
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Digite seu email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onSaved: (value) => password = value ?? '',
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Digite sua senha'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();

                        setState(() => loading = true);
                        try {
                          await auth.login(email: email, password: password);
                          if (mounted) {
                            Navigator.of(context).pushReplacementNamed('/cart');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                        setState(() => loading = false);
                      },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: const Text('Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
