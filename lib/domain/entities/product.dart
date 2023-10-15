class Product {
  final int id;
  final String name;
  final String? imageUrl;
  final double price;
  final int amount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.amount,
    this.imageUrl,
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

class ProductDTO {
  String name;
  int amount;

  ProductDTO(this.name, this.amount);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
