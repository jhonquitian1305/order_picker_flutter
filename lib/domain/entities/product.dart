class Product {
  final int id;
  final String name;
  final String? imageUrl;
  final double price;
  final int amount;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      amount: json['amount'],
    );
  }

  @override
  String toString() {
    return 'Product { id: $id, name: $name, imageUrl: $imageUrl, price: $price, amount: $amount}';
  }
}
