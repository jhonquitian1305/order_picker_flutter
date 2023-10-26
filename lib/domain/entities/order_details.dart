class OrderDetails {
  int id;
  double totalPrice;
  String user;
  String createdAt;
  List<ProductDetailsDTO> products;
  bool delivered;

  OrderDetails({
    required this.id,
    required this.totalPrice,
    required this.user,
    required this.createdAt,
    required this.products,
    required this.delivered,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json["idOrder"],
      totalPrice: json["totalPrice"],
      user: json["userName"],
      createdAt: json["createAt"],
      products: json["products"],
      delivered: json["delivered"],
    );
  }
}

class ProductDetailsDTO {
  String name;
  int amount;
  double unitPrice;

  ProductDetailsDTO(this.name, this.amount, this.unitPrice);

  factory ProductDetailsDTO.fromJson(Map<String, dynamic> json) {
    return ProductDetailsDTO(json["name"], json["amount"], json["unitPrice"]);
  }
}
