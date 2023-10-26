import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/rounded_text_field.dart';

void main() => runApp(const ProductsView());

class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {
  late Future<List<Product>> listProducts;

  List<ProductDTO> listProductsChose = [];

  Future<List<Product>> getProducts(User user) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Bearer ${user.jwt}"
    };
    final response =
        await http.get(Uri.parse("$url/products"), headers: requestHeaders);

    List<Product> products = [];
    print(response.body);
    print(response.statusCode);
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
    User? loggedUser = ref.read(authProvider).loggedUser;
    super.initState();
    listProducts = getProducts(loggedUser!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: [
                ...showListProducts(snapshot.data ?? []),
                buttonFinishOrder()
              ],
            ),
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

    return products;
  }

  Widget buttonFinishOrder() {
    finishOrder() async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrdersView(),
        ),
      );
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
        title: const Text("Choose amount"),
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Text("How many items of"),
            Text(
              ' ${product.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("do you want?"),
          ],
        ),
        actions: [
          RoundedTextField(
            controller: amountProduct,
            keyboardType: TextInputType.number,
            labelText: 'amount',
            hintText: "Enter amount of product.",
          ),
          const SizedBox(height: 10),
          Button(
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
