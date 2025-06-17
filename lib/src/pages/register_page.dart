import 'package:flutter/material.dart';
import 'package:in8shop_mobile_flutter/src/shared/providers/AuthProvider.dart';
import 'package:in8shop_mobile_flutter/src/shared/widgets/FormWrap.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: FormWrap(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Criar uma conta',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => name = value ?? '',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Digite seu nome' : null,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                obscureText: true,
                onSaved: (value) => confirmPassword = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value != password) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('As senhas não coincidem'),
                            ),
                          );
                          return;
                        }

                        setState(() => loading = true);
                        try {
                          await auth.register(
                            name: name,
                            email: email,
                            password: password,
                          );
                          if (mounted) {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/login');
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
                    : const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
