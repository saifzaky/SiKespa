import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isPatient => _currentUser?.role == 'patient';
  bool get isDoctor =>
      _currentUser?.role == 'doctor' || _currentUser?.role == 'admin';
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.getCurrentUserModel();
    result.fold(
      onSuccess: (user) {
        _currentUser = user;
        AppLogger.d('Auth initialized with user: ${user.email}');
      },
      onFailure: (error) {
        _currentUser = null;
        AppLogger.d('Auth initialized with no user');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        email: email,
        password: password,
        name: name,
        role: role,
      );

      return result.fold(
        onSuccess: (user) {
          _currentUser = user;
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
          AppLogger.i('Registration successful for: $email');
          return true;
        },
        onFailure: (error) {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
          AppLogger.w('Registration failed: $error');
          return false;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error in register', e, stackTrace);
      _errorMessage = 'Terjadi kesalahan tidak terduga';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      return result.fold(
        onSuccess: (user) {
          _currentUser = user;
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
          AppLogger.i('Login successful for: $email');
          return true;
        },
        onFailure: (error) {
          _errorMessage = error;
          _isLoading = false;
          notifyListeners();
          AppLogger.w('Login failed: $error');
          return false;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error in login', e, stackTrace);
      _errorMessage = 'Terjadi kesalahan tidak terduga';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final result = await _authService.logout();
    result.fold(
      onSuccess: (_) {
        _currentUser = null;
        _errorMessage = null;
        notifyListeners();
        AppLogger.i('Logout successful');
      },
      onFailure: (error) {
        _errorMessage = error;
        AppLogger.w('Logout failed: $error');
        // Still clear user even if logout fails
        _currentUser = null;
        notifyListeners();
      },
    );
  }

  Future<bool> resetPassword(String email) async {
    _errorMessage = null;

    final result = await _authService.resetPassword(email);
    return result.fold(
      onSuccess: (_) {
        AppLogger.i('Password reset email sent to: $email');
        return true;
      },
      onFailure: (error) {
        _errorMessage = error;
        AppLogger.w('Password reset failed: $error');
        return false;
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
