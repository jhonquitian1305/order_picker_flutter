import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';

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
      Uri.parse("http://my_ip:8080/api/order-picker/products"),
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
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                      '${product.name.toUpperCase()} ${product.price.toString()}'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersView(),
                        ),
                      );
                      setState(() {
                        counter++;
                      });
                      print(
                          'id: ${product.id} -> ${product.name}, amount : $counter');
                    },
                    child: const Row(
                      children: [Text("+")],
                    ),
                  ),
                  Text(counter.toString()),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        counter--;
                      });
                      print(
                          'id: ${product.id} -> ${product.name}, amount : $counter');
                    },
                    child: const Row(
                      children: [Text("-")],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return products;
  }
}
