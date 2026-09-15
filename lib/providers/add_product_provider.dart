import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/add_product_model.dart';
import '../repositories/add_product_repository.dart';
import '../services/image_picker_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;
  final ImagePickerService _imagePickerService;

  ProductProvider({
    ProductRepository? productRepository,
    ImagePickerService? imagePickerService,
  }) : _productRepository = productRepository ?? ProductRepository(),
       _imagePickerService = imagePickerService ?? ImagePickerService();

  bool _isLoading = false;
  String? _errorMessage;
  ProductModel? _createdProduct;
  List<ProductModel> _products = [];
  List<XFile> _selectedImages = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProductModel? get createdProduct => _createdProduct;
  List<ProductModel> get products => List.unmodifiable(_products);
  List<XFile> get selectedImages => List.unmodifiable(_selectedImages);

  Future<void> pickImages() async {
    try {
      _errorMessage = null;

      final List<XFile> images = await _imagePickerService.pickMultipleImages(
        maximumImages: 5,
      );

      _selectedImages = images;
      notifyListeners();
    } catch (error) {
      _errorMessage = _cleanErrorMessage(error);
      notifyListeners();
    }
  }

  void removeImage(int index) {
    if (index < 0 || index >= _selectedImages.length) {
      return;
    }

    final List<XFile> updatedImages = List<XFile>.from(_selectedImages);

    updatedImages.removeAt(index);

    _selectedImages = updatedImages;
    notifyListeners();
  }

  void clearSelectedImages() {
    _selectedImages = [];
    notifyListeners();
  }

  Future<ProductModel?> addProduct({
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
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _createdProduct = null;
    notifyListeners();

    try {
      final ProductModel product = await _productRepository.addProduct(
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
        images: _selectedImages,
      );

      _createdProduct = product;
      _products = [product, ..._products];

      _selectedImages = [];

      return product;
    } catch (error) {
      _errorMessage = _cleanErrorMessage(error);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getProducts();
    } catch (error) {
      _errorMessage = _cleanErrorMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanErrorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
