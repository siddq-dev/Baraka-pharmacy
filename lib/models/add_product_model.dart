import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String documentId;
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
    required this.documentId,
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

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'brandName': brandName,
      'chemicalName': chemicalName,
      'medicineName': medicineName,
      'description': description,
      'type': type,
      'quantity': quantity,
      'location': location,
      'price': price,
      'salePrice': salePrice,
      'imageUrls': imageUrls,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory ProductModel.fromMap(String documentId, Map<String, dynamic> map) {
    final dynamic storedImages = map['imageUrls'];

    final List<String> imageUrls = storedImages is List
        ? storedImages.whereType<String>().toList()
        : <String>[];

    return ProductModel(
      documentId: documentId,
      productId: map['productId'] as String? ?? '',
      brandName: map['brandName'] as String? ?? '',
      chemicalName: map['chemicalName'] as String? ?? '',
      medicineName: map['medicineName'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: map['type'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      location: map['location'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      salePrice: (map['salePrice'] as num?)?.toDouble() ?? 0,
      imageUrls: imageUrls,
      createdAt: _timestampToDate(map['createdAt']),
      updatedAt: _timestampToDate(map['updatedAt']),
    );
  }

  static DateTime? _timestampToDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }
}
