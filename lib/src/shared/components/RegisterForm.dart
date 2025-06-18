import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AuthProvider.dart';
import '../utils/toast.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        Toast.show(
          context,
          message: 'As senhas não coincidem',
          icon: Icons.warning_amber_outlined,
          background: Colors.orange,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
        return;
      }

      setState(() => isLoading = true);
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.register(name: name, email: email, password: password);

        Toast.show(
          context,
          message: 'Cadastro realizado com sucesso!',
          icon: Icons.check_circle_outline,
          background: Colors.green,
          textColor: Colors.white,
          iconColor: Colors.white,
        );

        Navigator.of(context).pop(); // 🔥 Volta pro login
      } catch (e) {
        Toast.show(
          context,
          message: e.toString().replaceAll('Exception: ', ''),
          icon: Icons.error_outline,
          background: Colors.red.shade700,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (v) => name = v,
                validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (v) => email = v,
                validator: (v) => v!.isEmpty ? 'Informe seu email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onChanged: (v) => password = v,
                validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                onChanged: (v) => confirmPassword = v,
                validator: (v) => v!.isEmpty ? 'Confirme sua senha' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    : const Text('Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Já tem conta? Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
