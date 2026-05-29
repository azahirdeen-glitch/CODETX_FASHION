import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/db_service.dart';

class ProductProvider extends ChangeNotifier {
  final DbService _dbService = DbService();
  
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _activeCategory = 'All';
  
  StreamSubscription<List<ProductModel>>? _productsSubscription;

  ProductProvider() {
    // Stream products in real-time from Firestore
    _isLoading = true;
    _productsSubscription = _dbService.streamProducts().listen((List<ProductModel> list) {
      _products = list;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _isLoading = false;
      notifyListeners();
    });
  }

  // Getters
  List<ProductModel> get allProducts => _products;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get activeCategory => _activeCategory;

  // Filtered products list based on active category and search query
  List<ProductModel> get filteredProducts {
    return _products.where((p) {
      final matchesCategory = _activeCategory == 'All' || p.category.toLowerCase() == _activeCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty || p.title.toLowerCase().contains(_searchQuery.toLowerCase()) || p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Category change
  void setActiveCategory(String category) {
    _activeCategory = category;
    notifyListeners();
  }

  // Search filter
  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }



  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}
