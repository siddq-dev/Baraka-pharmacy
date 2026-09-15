import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String productId;
  final String brandName;
  final String chemicalName;
  final String medicineName;
  final String description;
  final String type;
  final int quantity;
  final String location;
  final double price;
  final double salePrice;
  final List<String> imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.productId,
    required this.brandName,
    required this.chemicalName,
    required this.medicineName,
    required this.description,
    required this.type,
    required this.quantity,
    required this.location,
    required this.price,
    required this.salePrice,
    required this.imageUrls,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};

    final createdTimestamp = data['createdAt'];
    final updatedTimestamp = data['updatedAt'];

    return ProductModel(
      id: document.id,
      productId: data['productId']?.toString() ?? '',
      brandName: data['brandName']?.toString() ?? '',
      chemicalName: data['chemicalName']?.toString() ?? '',
      medicineName: data['medicineName']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      type: data['type']?.toString() ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      location: data['location']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
      imageUrls: _extractImageUrls(data['imageUrls']),
      createdAt: createdTimestamp is Timestamp
          ? createdTimestamp.toDate()
          : null,
      updatedAt: updatedTimestamp is Timestamp
          ? updatedTimestamp.toDate()
          : null,
    );
  }

  static List<String> _extractImageUrls(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }

    return <String>[];
  }

  bool get isAvailable => quantity > 0;

  double get displayPrice {
    if (salePrice > 0 && salePrice < price) {
      return salePrice;
    }

    return price;
  }

  bool get hasDiscount => salePrice > 0 && salePrice < price;
}
