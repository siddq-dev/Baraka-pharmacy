import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../routes/role_redirect.dart';
import '../models/customer_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;

  User? _user;
  CustomerModel? _customer;
  UserRole? _role;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  User? get user => _user;

  CustomerModel? get customer => _customer;

  UserRole get role => _role ?? UserRole.customer;

  String get homeRoute => RoleRedirect.homeRouteFor(role);

  bool get isAuthenticated => _user != null;

  Future<bool> register({
    required String email,
    required String contactNumber,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final customer = await _authRepository.registerCustomer(
        email: email,
        contactNumber: contactNumber,
        password: password,
      );

      _user = _authRepository.currentUser;
      _customer = customer;

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      return false;
    } catch (_) {
      _errorMessage = 'Unable to create your account. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      final credential = await _authRepository.login(
        email: email,
        password: password,
      );

      _user = credential.user;

      if (_user != null) {
        _role = await _authRepository.getUserRole(_user!.uid);

        if (_role == UserRole.customer) {
          _customer = await _authRepository.getCustomerProfile(_user!.uid);
        }
      }

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      return false;
    } catch (_) {
      _errorMessage = 'Unable to login. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.logout();

      _user = null;
      _customer = null;
      _role = null;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _clearError();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';

      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled.';

      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'user-not-found':
        return 'No account was found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
