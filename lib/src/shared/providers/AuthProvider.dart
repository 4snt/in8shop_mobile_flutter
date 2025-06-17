import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  /// 🚀 Carrega token e user salvos localmente
  Future<void> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userString = prefs.getString('user');

    if (userString != null) {
      _user = jsonDecode(userString);
    }

    notifyListeners();
  }

  /// 🔑 Login
  Future<void> login({required String email, required String password}) async {
    final data = await _authService.login(email: email, password: password);

    _saveAuthData(data);
  }

  /// 📝 Cadastro
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _authService.register(
      name: name,
      email: email,
      password: password,
    );

    _saveAuthData(data);
  }

  /// 👤 Buscar dados do usuário autenticado na API
  Future<void> fetchCurrentUser() async {
    if (_token == null) return;

    final user = await _authService.getCurrentUser(token: _token!);
    _user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));

    notifyListeners();
  }

  /// 🚪 Logout completo
  Future<void> logout() async {
    try {
      await _authService.logout(); // limpa token e user do local
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }

    _token = null;
    _user = null;

    notifyListeners();
  }

  /// 💾 Salva token e user localmente
  void _saveAuthData(Map<String, dynamic> data) async {
    _token = data['token'];
    _user = data['user'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('user', jsonEncode(_user!));

    notifyListeners();
  }

  /// 🪪 Debug — printa auth salva
  void debugAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedUser = prefs.getString('user');

    print('→ Token salvo: $savedToken');
    print('→ User salvo: $savedUser');
    print('→ Em memória → token: $_token | user: $_user');
  }
}
