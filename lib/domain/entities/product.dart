class Product {
  int id;
  String name;
  int amount;
  double price;

  Product(this.id, this.name, this.amount, this.price);
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
