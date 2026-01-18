class Product {
  int id;
  String name;
  String title;
  String category;
  double price;
  int stock;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.title,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    price: json['price'] ?? 0.0,
    stock: json['stock'] ?? 0,
    image: json['image'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'price': price,
      'category': category,
      'stock': stock,
      'image': image,
    };
  }
}
