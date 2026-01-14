import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isInitialLoading = true;
  bool _isBusy = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isInitialLoading => _isInitialLoading;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? firebaseUser) async {
      try {
        if (firebaseUser != null) {
          _user = await _authService.getUserData(firebaseUser.uid);
        } else {
          _user = null;
        }
      } catch (e) {
        _user = null;
      } finally {
        _isInitialLoading = false;
        _isBusy = false;
        notifyListeners();
      }
    });
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _setBusy(true);
      _errorMessage = null;

      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setBusy(false);
    }
  }

  // Sign in
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _setBusy(true);
      _errorMessage = null;

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setBusy(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setBusy(true);
      await _authService.signOut();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setBusy(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setBusy(true);
      _errorMessage = null;
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setBusy(false);
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }
}
