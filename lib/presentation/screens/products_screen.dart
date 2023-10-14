import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/infrastructure/datasources/url_string.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';
import 'package:order_picker/presentation/widgets/button_card.dart';

void main() => runApp(const ProductsView());

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  int counter = 0;
  late Future<List<Product>> listProducts;

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
                  onPressed: () {},
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
    finishOrder() {
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
}
