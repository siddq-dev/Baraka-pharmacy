import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../routes/role_redirect.dart';
import '../models/customer_model.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createCustomerProfile({required CustomerModel customer}) async {
    final batch = _firestore.batch();

    batch.set(
      _firestore.collection('customers').doc(customer.uid),
      customer.toFirestore(),
    );

    batch.set(_firestore.collection('users').doc(customer.uid), {
      'role': customer.role,
      'uid': customer.uid,
    });

    await batch.commit();
  }

  Future<CustomerModel?> getCustomerProfile(String uid) async {
    final snapshot = await _firestore.collection('customers').doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return CustomerModel.fromFirestore(snapshot);
  }

  Future<UserRole> getUserRole(String uid) async {
    // Preferred source of truth: a top-level `users/{uid}` doc with a `role` field.
    final userDoc = await _firestore.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data()?['role'] != null) {
      return UserRole.fromString(userDoc.data()!['role'] as String?);
    }

    // Backward-compat fallback for accounts created before `users` existed.
    final customerDoc = await _firestore.collection('customers').doc(uid).get();

    if (customerDoc.exists) {
      return UserRole.fromString(
        customerDoc.data()?['role'] as String? ?? 'customer',
      );
    }

    return UserRole.customer;
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
