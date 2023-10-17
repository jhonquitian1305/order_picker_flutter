import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/button_card.dart';

void main() => runApp(const ProductsView());

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late Future<List<Product>> listProducts;

  List<ProductDTO> listProductsChose = [];

  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse("$url/products"),
    );

    List<Product> products = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var product in jsonData["content"]) {
        products.add(
          Product(
            id: product["id"],
            name: product["name"],
            amount: product["amount"],
            price: product["price"],
          ),
        );
      }
      return products;
    } else {
      throw Exception("Connection Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    listProducts = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: showListProducts(snapshot.data ?? []),
          );
        } else if (snapshot.hasError) {
          return const Text("Error");
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Widget> showListProducts(List<Product> data) {
    List<Widget> products = [];
    for (var product in data) {
      products.add(
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xff555555)),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Price: \$ ${product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(85, 85, 85, 1.0),
                      ),
                    ),
                  ],
                ),
                Button(
                  onPressed: () {
                    chooseAmount(context, product);
                  },
                  child: const ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Icon(
                      Icons.add_shopping_cart_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    products.add(buttonFinishOrder());

    return products;
  }

  Widget buttonFinishOrder() {
    finishOrder() async {
      for (var product in listProductsChose) {
        print("${product.name} ${product.amount}");
      }
      try {
        Response response = await post(Uri.parse("$url/orders/user/1"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "products": listProductsChose,
            }));
        print(response.statusCode);
        listProductsChose = [];
      } catch (e) {
        print(e.toString());
        print("Jeison te amo");
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrdersView(),
        ),
      );
    }

    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Button(
                onPressed: finishOrder,
                child: const Text("Finish Order"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  chooseAmount(BuildContext context, Product product) {
    TextEditingController amountProduct = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bienvenido"),
        content: const Text("Hola"),
        actions: [
          TextField(
            controller: amountProduct,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'amount',
              hintText: "Enter amount of product.",
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () {
              String amountText = amountProduct.text;
              int amount = int.tryParse(amountText) ?? 0;

              ProductDTO productChose = ProductDTO(
                product.name.toString(),
                amount,
              );
              listProductsChose.add(productChose);
              amountProduct.clear();
            },
            child: const Text(
              "Aceptar",
            ),
          ),
        ],
      ),
    );
  }
}
