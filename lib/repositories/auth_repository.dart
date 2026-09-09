import 'package:firebase_auth/firebase_auth.dart';

import '../routes/role_redirect.dart';
import '../models/customer_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<CustomerModel> registerCustomer({
    required String email,
    required String contactNumber,
    required String password,
  }) async {
    final credential = await _authService.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-created',
        message: 'Unable to create the user account.',
      );
    }

    final customer = CustomerModel(
      uid: user.uid,
      email: email,
      contactNumber: contactNumber,
      role: 'customer',
      isActive: true,
      createdAt: DateTime.now(),
    );

    await _authService.createCustomerProfile(customer: customer);

    return customer;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<CustomerModel?> getCustomerProfile(String uid) {
    return _authService.getCustomerProfile(uid);
  }

  Future<UserRole> getUserRole(String uid) {
    return _authService.getUserRole(uid);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
}
