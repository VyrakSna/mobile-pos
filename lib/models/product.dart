class Product {
  int id;
  String title;
  String category;
  double price;
  int stock = 100;
  String image;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    stock: 100,
    image: json['image'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'stock': 100,
      'image': image,
    };
  }
}
