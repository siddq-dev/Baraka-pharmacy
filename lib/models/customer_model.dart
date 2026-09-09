import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String uid;
  final String email;
  final String contactNumber;
  final String role;
  final bool isActive;
  final DateTime? createdAt;

  const CustomerModel({
    required this.uid,
    required this.email,
    required this.contactNumber,
    required this.role,
    required this.isActive,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'contactNumber': contactNumber,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory CustomerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    final createdAtValue = data['createdAt'];

    DateTime? createdAt;

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    }

    return CustomerModel(
      uid: data['uid'] as String? ?? snapshot.id,
      email: data['email'] as String? ?? '',
      contactNumber: data['contactNumber'] as String? ?? '',
      role: data['role'] as String? ?? 'customer',
      isActive: data['isActive'] as bool? ?? true,
      createdAt: createdAt,
    );
  }
}
