import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:order_picker/domain/entities/order.dart';
import 'package:order_picker/domain/entities/order_details.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:http/http.dart' as http;
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/widgets/button.dart';

void main() => runApp(const OrderDetailView());

class OrderDetailView extends ConsumerStatefulWidget {
  const OrderDetailView({super.key, this.idDetailOrder});

  final IdDetailOrder? idDetailOrder;

  @override
  ConsumerState<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends ConsumerState<OrderDetailView> {
  late Future<OrderDetails> orderDetails;
  Future<OrderDetails> getDetailOrders(
      String jwt, IdDetailOrder? idDetailOrder) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $jwt"
    };

    int? userId = idDetailOrder!.userId;
    int? orderId = idDetailOrder.orderId;

    List<ProductDetailsDTO> productList = [];

    final response = await http.get(
        Uri.parse("$url/orders/order-details/$userId/$orderId"),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      for (var product in jsonData["products"]) {
        productList.add(
          ProductDetailsDTO.fromJson(product),
        );
      }
      jsonData["products"] = productList;

      return OrderDetails.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to get order details, status code: ${response.statusCode}',
      );
    }
  }

  @override
  void initState() {
    User? loggedUser = ref.read(authProvider).loggedUser;
    int? userId = widget.idDetailOrder!.userId;
    int? orderId = widget.idDetailOrder!.orderId;
    print("$url/orders/order-details/$userId/$orderId");
    super.initState();
    orderDetails = getDetailOrders(loggedUser!.jwt, widget.idDetailOrder);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DateTime date = DateTime.parse(snapshot.data!.createdAt);
            final formatDate = DateFormat('dd MMMM, yyyy - HH:mm').format(date);
            return Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: ListView(
                children: [
                  Center(
                    child: MessageEmployee(snapshot.data!.id),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Total: ${snapshot.data!.totalPrice.toString()}",
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "User: ${snapshot.data!.user.toString()}",
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "Date: $formatDate",
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    snapshot.data!.delivered.toString(),
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  ...showProductsOrdered(snapshot.data!.products),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          child: const Text("Create Order"),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button(
                          type: ButtonType.secondary,
                          onPressed: () {},
                          child: const Text("Mark Delivered"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("Error");
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  showProductsOrdered(List<ProductDetailsDTO> dataProducts) {
    List<Widget> products = [];

    for (var product in dataProducts) {
      products.add(
        Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xff555555)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "price: ${product.unitPrice.toString()}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Center(
                      child: Text(
                        "amount: ${product.amount.toString()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return products;
  }
}

class MessageEmployee extends StatelessWidget {
  final int? id;
  const MessageEmployee(int this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Admin, here are the order N° $id details",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const WidgetSpan(
            child: Icon(
              Icons.card_giftcard_rounded,
              size: 24,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
