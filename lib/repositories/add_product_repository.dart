import 'package:barakaa/services/add_product_service.dart';
import 'package:image_picker/image_picker.dart';

import '../models/add_product_model.dart';
import '../services/storage_service.dart';

class ProductRepository {
  final ProductService _productService;
  final StorageService _storageService;

  ProductRepository({
    ProductService? productService,
    StorageService? storageService,
  }) : _productService = productService ?? ProductService(),
       _storageService = storageService ?? StorageService();

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
    required List<XFile> images,
  }) async {
    final String temporaryProductId = DateTime.now().millisecondsSinceEpoch
        .toString();

    final List<String> imageUrls = await _storageService.uploadProductImages(
      images: images,
      productId: temporaryProductId,
    );

    final ProductModel product = await _productService.addProduct(
      companyName: companyName,
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

    return product;
  }

  Future<List<ProductModel>> getProducts() {
    return _productService.getProducts();
  }
}
