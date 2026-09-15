import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider({ProductRepository? repository})
    : _repository = repository ?? ProductRepository();

  StreamSubscription<List<ProductModel>>? _productsSubscription;

  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<ProductModel> get products => List.unmodifiable(_products);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  void startListening() {
    if (_productsSubscription != null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _productsSubscription = _repository.watchProducts().listen(
      (products) {
        _products = products;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}
