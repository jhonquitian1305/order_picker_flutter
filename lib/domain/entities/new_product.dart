import 'dart:io';

class NewProduct {
  String? name;
  File? image;
  double? price;
  int? amount;

  NewProduct();

  //getters
  String? get getName => name;
  File? get getImage => image;
  double? get getPrice => price;
  int? get getAmount => amount;

  //setters
  set setName(String name) => name = name;
  set setImage(File image) => image = image;
  set setPrice(double price) => price = price;
  set setAmount(int amount) => amount = amount;

  @override
  String toString() {
    return 'NewProduct { name: $name, image: $image, price: $price, amount: $amount}';
  }

  isValid() {
    return name != null &&
        name!.isNotEmpty &&
        price != null &&
        amount != null &&
        image != null;
  }
}
