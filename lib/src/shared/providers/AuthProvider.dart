import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usermodel.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  UserModel? _user;

  String? get token => _token;
  UserModel? get user => _user;
  bool get isAuthenticated => _token != null;

  Future<void> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userString = prefs.getString('user');

    if (userString != null) {
      _user = UserModel.fromJson(userString);
    }

    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final data = await _authService.login(email: email, password: password);

    _saveAuthData(data);
  }

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

  Future<void> fetchCurrentUser() async {
    if (_token == null) return;

    final userMap = await _authService.getCurrentUser(token: _token!);
    _user = UserModel.fromMap(userMap);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', _user!.toJson());

    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }

    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    notifyListeners();
  }

  /// 💾 Salva token e user localmente
  void _saveAuthData(Map<String, dynamic> data) async {
    _token = data['token'];
    _user = UserModel.fromMap(data['user']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('user', _user!.toJson());

    notifyListeners();
  }

  /// 🪪 Debug — printa auth salva
  void debugAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedUser = prefs.getString('user');

    print('→ Token salvo: $savedToken');
    print('→ User salvo: $savedUser');
    print('→ Em memória → token: $_token | user: ${_user?.toMap()}');
  }
}
