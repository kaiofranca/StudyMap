import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  UserEntity? _user;
  bool _isLoading = false;

  AuthController(this._authRepository) {
    _authRepository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  UserEntity? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepository.loginWithEmail(email, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepository.registerWithEmailAndPassword(email, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginWithGoogle() async {
    _setLoading(true);
    try {
      await _authRepository.loginWithGoogle();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
