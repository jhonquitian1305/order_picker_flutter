import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
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
  Future<OrderDetails> getDetailOrders(String jwt) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $jwt"
    };

    int? userId = widget.idDetailOrder!.userId;
    int? orderId = widget.idDetailOrder!.orderId;

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
    super.initState();
    orderDetails = getDetailOrders(loggedUser!.jwt);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? loggedUser = ref.read(authProvider).loggedUser;
            String isDelivered =
                snapshot.data!.delivered ? "Delivered" : "Pending";
            Color colorDelivered = snapshot.data!.delivered
                ? const Color(0xFF07924F)
                : const Color(0xFFDF1010);
            DateTime date = DateTime.parse(snapshot.data!.createdAt);
            final formatDate = DateFormat('dd MMMM, yyyy - HH:mm').format(date);
            bool visibleButton;
            List<Role> rolesAdmin = [];
            rolesAdmin.add(Role.admin);
            rolesAdmin.add(Role.employee);
            if (rolesAdmin.contains(loggedUser!.role)) {
              visibleButton = true;
            } else {
              visibleButton = false;
            }

            return Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: ListView(
                children: [
                  Center(
                    child: MessageUser(snapshot.data!.id),
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
                    "State: $isDelivered",
                    style: TextStyle(
                      color: colorDelivered,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  ...showProductsOrdered(snapshot.data!.products),
                  IgnorePointer(
                    ignoring: snapshot.data!.delivered ? true : false,
                    child: Opacity(
                      opacity: snapshot.data!.delivered ? 0.2 : 1,
                      child: Visibility(
                        visible: visibleButton,
                        child: Button(
                          onPressed: () {
                            print("hola");
                            markDelivered(snapshot.data, loggedUser.jwt);
                          },
                          child: const Text("Mark Delivered"),
                        ),
                      ),
                    ),
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

  markDelivered(OrderDetails? orderDetails, String jwt) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $jwt"
    };
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Mark order as delivered"),
        content: Text("Are you sure of mark this order as delivered?"),
        actions: [
          Row(
            children: [
              Expanded(
                child: Button(
                  child: Text("OK"),
                  onPressed: () async {
                    Navigator.pop(context);
                    await patch(Uri.parse("$url/orders/${orderDetails!.id}"),
                        headers: requestHeaders);
                    setState(() {
                      orderDetails.delivered = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Button(
                    type: ButtonType.secondary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
              ),
            ],
          ),
        ],
      ),
    );
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

class MessageUser extends StatelessWidget {
  final int? id;
  const MessageUser(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Here are the order N° $id details",
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
