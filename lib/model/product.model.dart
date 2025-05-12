class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle potential null values by providing defaults
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: _parseDoubleValue(json['price']),
      discountPercentage: _parseDoubleValue(json['discountPercentage']),
      rating: _parseDoubleValue(json['rating']),
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: _parseStringList(json['images']),
    );
  }

  // Helper method to safely parse double values
  static double _parseDoubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  // Helper method to safely parse string lists
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) => item?.toString() ?? '').toList();
    }
    return [];
  }
}
