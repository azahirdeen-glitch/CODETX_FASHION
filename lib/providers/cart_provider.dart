import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  final String size;

  CartItem({
    required this.product,
    required this.quantity,
    required this.size,
  });

  double get totalPrice => product.discountedPrice * quantity;

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    String? size,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Subtotal calculated with the actual discounted prices
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Tax calculation (8% as custom standard)
  double get tax => subtotal * 0.08;

  // Final Total
  double get total => subtotal + tax;

  // Add Item to Cart
  void addItem(ProductModel product, {required String size}) {
    final int index = _items.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index >= 0) {
      // Item already in cart, increment quantity
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      // New item
      _items.add(CartItem(product: product, quantity: 1, size: size));
    }
    notifyListeners();
  }

  // Increment Quantity
  void incrementQuantity(String productId, String size) {
    final int index = _items.indexWhere(
      (item) => item.product.id == productId && item.size == size,
    );

    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
      notifyListeners();
    }
  }

  // Decrement Quantity
  void decrementQuantity(String productId, String size) {
    final int index = _items.indexWhere(
      (item) => item.product.id == productId && item.size == size,
    );

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Remove Item Completely
  void removeItem(String productId, String size) {
    _items.removeWhere((item) => item.product.id == productId && item.size == size);
    notifyListeners();
  }

  // Clear Cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
