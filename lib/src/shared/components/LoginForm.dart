import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../providers/AuthProvider.dart';
import '../utils/toast.dart';
import './RegisterForm.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.login(email: email, password: password);

        Toast.show(
          context,
          message: 'Login realizado com sucesso!',
          icon: Icons.check_circle_outline,
          background: Colors.green,
          textColor: Colors.white,
          iconColor: Colors.white,
        );

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(
            context,
          ).pop(); // Volta pra tela anterior (ex.: Checkout ou Carrinho)
        });
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    : const Text('Entrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterForm()),
                  );
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
