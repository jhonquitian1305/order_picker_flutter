import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_picker/domain/entities/order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/screens/new_order_screen.dart';
import 'package:order_picker/presentation/screens/order_detail_screen.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(const OrdersView());

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  late Future<List<Order>> listOrders;

  Future<List<Order>> getOrders(User user) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer ${user.jwt}"
    };
    List<Role> rolesAdmin = [];
    rolesAdmin.add(Role.admin);
    rolesAdmin.add(Role.employee);

    final http.Response response;
    if (rolesAdmin.contains(user.role)) {
      response = await http.get(Uri.parse("$url/orders?pageSize=20"),
          headers: requestHeaders);
    } else {
      response = await http.get(Uri.parse("$url/orders/user/${user.id}"),
          headers: requestHeaders);
    }
    List<Order> orders = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var order in jsonData["content"]) {
        orders.add(
          Order(
            order["id"],
            order["userId"],
            order["totalPrice"],
            order["isDelivered"],
            order["createdAt"],
          ),
        );
      }
      return orders;
    } else {
      throw Exception("Connection Failed");
    }
  }

  @override
  void initState() {
    User? loggedUser = ref.read(authProvider).loggedUser;
    super.initState();
    listOrders = getOrders(loggedUser!);
  }

  constructor() {}

  @override
  Widget build(BuildContext context) {
    User? loggedUser = ref.read(authProvider).loggedUser;
    _createNewOrder() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewOrderScreen(),
        ),
      );
    }

    return FutureBuilder(
        future: listOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ...showListOrders(snapshot.data ?? []),
                Button(
                  onPressed: _createNewOrder,
                  child: const Text("New Order"),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text("Error");
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  List<Widget> showListOrders(List<Order> data) {
    User? loggedUser = ref.read(authProvider).loggedUser;
    List<Widget> orders = [];

    for (var order in data) {
      String isDelivered = order.isDelivered ? "Delivered" : "Pending";
      DateTime date = DateTime.parse(order.createAt);
      final formatDate = DateFormat('dd MMMM, yyyy').format(date);
      String relativeDate;

      if (DateTime.now().difference(date) < const Duration(days: 30)) {
        relativeDate = timeago.format(date);
      } else {
        relativeDate = formatDate;
      }
      Color colorDelivered =
          order.isDelivered ? const Color(0xFF07924F) : const Color(0xFFDF1010);
      orders.add(
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xff555555)),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              IdDetailOrder idDetailOrder = IdDetailOrder(0, 0);
              idDetailOrder.orderId = order.id;
              if (loggedUser!.role == Role.admin) {
                idDetailOrder.userId = order.userId;
              } else {
                idDetailOrder.userId = loggedUser.id;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailView(
                    idDetailOrder: idDetailOrder,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order N° ${order.id}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        relativeDate,
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        "\$ ${order.totalPrice}",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    isDelivered,
                    style: TextStyle(
                      color: colorDelivered,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return orders;
  }
}
