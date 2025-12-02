import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _loading = false;
  String? _error;
  bool _disposed = false;
  StreamSubscription<User?>? _authStateSubscription;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  AuthViewModel() {
    checkAuthState();
  }

  void _setLoading(bool loading) {
    _loading = loading;
    _safeNotifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    _safeNotifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final user =
          await _authService.signInWithEmailAndPassword(email, password);
      _setUser(user);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final user =
          await _authService.registerWithEmailAndPassword(email, password);
      _setUser(user);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _setUser(null);
  }

  // Alias for logout to match expected method name in profile_screen
  Future<void> logout() async {
    await signOut();
  }

  void checkAuthState() {
    _authStateSubscription = _authService.user.listen((user) {
      _setUser(user);
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
