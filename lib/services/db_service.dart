import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- PRODUCTS ---

  // Stream of all products from Firestore
  Stream<List<ProductModel>> streamProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // --- USER PROFILE ---

  // Stream user profile data
  Stream<UserModel?> streamUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Update user personal details, addresses, or payment cards
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // --- ORDERS ---

  // Place a new customer order
  Future<void> placeOrder(OrderModel order) async {
    try {
      await _db.collection('orders').doc(order.id).set(order.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Fetch past orders for a specific user, sorted by date (newest first)
  Stream<List<OrderModel>> streamUserOrders(String uid) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort in memory just in case the Firestore composite index is not yet built
      orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return orders;
    });
  }
}
