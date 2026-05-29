import 'user_model.dart';

class OrderItemModel {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final String size;

  OrderItemModel({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.size,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'size': size,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
      size: map['size'] ?? 'M',
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double tax;
  final double totalAmount;
  final AddressModel shippingAddress;
  final PaymentCardModel paymentCard;
  final String status;
  final DateTime timestamp;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentCard,
    this.status = 'Processing',
    required this.timestamp,
  });

  String get formattedTotal => 'LKR ${totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  String get formattedSubtotal => 'LKR ${subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  String get formattedTax => 'LKR ${tax.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((x) => x.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toMap(),
      'paymentCard': paymentCard.toMap(),
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      userId: map['userId'] ?? '',
      items: List<OrderItemModel>.from(
        (map['items'] as List<dynamic>?)?.map((x) => OrderItemModel.fromMap(Map<String, dynamic>.from(x))) ?? const [],
      ),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: AddressModel.fromMap(Map<String, dynamic>.from(map['shippingAddress'] ?? {})),
      paymentCard: PaymentCardModel.fromMap(Map<String, dynamic>.from(map['paymentCard'] ?? {})),
      status: map['status'] ?? 'Processing',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
    );
  }
}
