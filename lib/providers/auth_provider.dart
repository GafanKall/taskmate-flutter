import 'package:flutter/material.dart';
import 'package:taskmate/models/user.dart';
import 'package:taskmate/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['access_token'];
      await apiService.saveToken(token);
      _user = User.fromJson(response.data['user']);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _setLoading(true);
    try {
      final response = await apiService.dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final token = response.data['access_token'];
      await apiService.saveToken(token);
      _user = User.fromJson(response.data['user']);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await apiService.dio.post('/logout');
      await apiService.deleteToken();
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      // Even if API fails, clear local token
      await apiService.deleteToken();
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await apiService.getToken();
    if (token != null) {
      try {
        final response = await apiService.dio.get('/me');
        _user = User.fromJson(response.data);
        _isAuthenticated = true;
      } catch (e) {
        await apiService.deleteToken();
        _isAuthenticated = false;
      }
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
