import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;

  final AuthService _authService = AuthService();

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  /// 🔥 Carregar dados salvos localmente (token + user)
  Future<void> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userString = prefs.getString('user');
    if (userString != null) {
      _user = jsonDecode(userString);
    }
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final data = await _authService.login(email: email, password: password);
    final token = data['token'];
    final user = data['user'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user));

    _token = token;
    _user = user;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _authService.register(name: name, email: email, password: password);
  }

  Future<void> fetchCurrentUser() async {
    if (_token == null) return;
    final user = await _authService.getCurrentUser(token: _token!);
    _user = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _token = null;
    _user = null;
    notifyListeners();
  }
}
