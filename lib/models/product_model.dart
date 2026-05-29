class ProductModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category;
  final String description;
  final bool isBestseller;
  final int discountPercent;
  final List<String> sizes;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
    this.isBestseller = false,
    this.discountPercent = 0,
    this.sizes = const ['S', 'M', 'L', 'XL'],
  });

  double get discountedPrice {
    if (discountPercent <= 0) return price;
    return price * (1 - discountPercent / 100);
  }

  String get formattedPrice => 'LKR ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  String get formattedDiscountedPrice => 'LKR ${discountedPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'isBestseller': isBestseller,
      'discountPercent': discountPercent,
      'sizes': sizes,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      title: map['title'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'Outfits',
      description: map['description'] ?? '',
      isBestseller: map['isBestseller'] ?? false,
      discountPercent: map['discountPercent'] ?? 0,
      sizes: List<String>.from(map['sizes'] ?? ['S', 'M', 'L', 'XL']),
    );
  }
}
