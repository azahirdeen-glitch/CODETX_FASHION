import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/db_service.dart';

class OrderProvider extends ChangeNotifier {
  final DbService _dbService = DbService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  // Stream past orders in real-time for current user
  void startOrdersListener(String uid) {
    _ordersSubscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _ordersSubscription = _dbService.streamUserOrders(uid).listen((List<OrderModel> list) {
      _orders = list;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _isLoading = false;
      notifyListeners();
    });
  }

  // Stop listening (e.g. on logout)
  void stopOrdersListener() {
    _ordersSubscription?.cancel();
    _ordersSubscription = null;
    _orders = [];
    notifyListeners();
  }

  // Place a new order in Firestore
  Future<void> checkout({
    required String userId,
    required List<OrderItemModel> items,
    required double subtotal,
    required double tax,
    required double totalAmount,
    required dynamic shippingAddress, // AddressModel
    required dynamic paymentCard,     // PaymentCardModel
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final String newOrderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final OrderModel newOrder = OrderModel(
        id: newOrderId,
        userId: userId,
        items: items,
        subtotal: subtotal,
        tax: tax,
        totalAmount: totalAmount,
        shippingAddress: shippingAddress,
        paymentCard: paymentCard,
        status: 'Processing',
        timestamp: DateTime.now(),
      );

      await _dbService.placeOrder(newOrder);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
