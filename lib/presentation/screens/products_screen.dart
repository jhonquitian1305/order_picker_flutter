import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';
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
          Product(product["id"], product["name"], product["amount"],
              product["price"]),
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
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Products list'),
        ),
        body: FutureBuilder(
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
        ),
      ),
    );
  }

  List<Widget> showListProducts(List<Product> data) {
    List<Widget> products = [];

    for (var product in data) {
      products.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xff555555)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white,
          child: Stack(
            children: [
              SizedBox(
                width: 380,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 10),
                  child: Text(
                    product.name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 45,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '\$ ${product.price}',
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 10,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const CircleBorder(
                      side: BorderSide(color: Color(0xff555555)),
                    ),
                  ),
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
              ),
            ],
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
              ButtonCard(
                context: context,
                text: "Finish Order",
                onPressed: finishOrder,
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
