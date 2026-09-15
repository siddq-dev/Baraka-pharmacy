import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/add_product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _productsCollection {
    return _firestore.collection('products');
  }

  DocumentReference<Map<String, dynamic>> get _counterDocument {
    return _firestore.collection('counters').doc('products');
  }

  Future<ProductModel> addProduct({
    required String companyName,
    required String brandName,
    required String chemicalName,
    required String medicineName,
    required String description,
    required String type,
    required int quantity,
    required String location,
    required double price,
    required double salePrice,
    required List<String> imageUrls,
  }) async {
    final DocumentReference<Map<String, dynamic>> productDocument =
        _productsCollection.doc();

    final ProductModel product = await _firestore.runTransaction<ProductModel>((
      transaction,
    ) async {
      final DocumentSnapshot<Map<String, dynamic>> counterSnapshot =
          await transaction.get(_counterDocument);

      final int currentNumber =
          (counterSnapshot.data()?['lastProductNumber'] as num?)?.toInt() ?? 0;

      final int nextNumber = currentNumber + 1;

      final String sequenceNumber = nextNumber.toString().padLeft(3, '0');

      final String generatedProductId = '$companyName-$sequenceNumber';

      final ProductModel productModel = ProductModel(
        documentId: productDocument.id,
        productId: generatedProductId,
        brandName: brandName,
        chemicalName: chemicalName,
        medicineName: medicineName,
        description: description,
        type: type,
        quantity: quantity,
        location: location,
        price: price,
        salePrice: salePrice,
        imageUrls: imageUrls,
      );

      transaction.set(_counterDocument, {
        'lastProductNumber': nextNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      transaction.set(productDocument, productModel.toMap());

      return productModel;
    });

    return product;
  }

  Future<List<ProductModel>> getProducts() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _productsCollection.orderBy('createdAt', descending: true).get();

    return snapshot.docs
        .map((document) => ProductModel.fromMap(document.id, document.data()))
        .toList();
  }
}
