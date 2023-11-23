class Order {
  int id;
  int? userId;
  double totalPrice;
  bool isDelivered;
  String createAt;

  Order(this.id, this.userId, this.totalPrice, this.isDelivered, this.createAt);
}

class IdDetailOrder {
  int? userId;
  int orderId;

  IdDetailOrder(this.userId, this.orderId);
}
