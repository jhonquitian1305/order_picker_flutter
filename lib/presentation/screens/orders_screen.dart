import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_picker/domain/entities/order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() => runApp(const OrdersView());

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late Future<List<Order>> listOrders;

  Future<List<Order>> getOrders() async {
    final response = await http.get(
      Uri.parse("http://my_ip:8080/api/order-picker/orders"),
    );

    List<Order> orders = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var order in jsonData["content"]) {
        orders.add(
          Order(
            order["id"],
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
    super.initState();
    listOrders = getOrders();
    print("Hola");
  }

  constructor() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Orders List'),
        ),
        body: FutureBuilder(
            future: listOrders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: showListOrders(snapshot.data ?? []),
                );
              } else if (snapshot.hasError) {
                return const Text("Error");
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  List<Widget> showListOrders(List<Order> data) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          margin: const EdgeInsets.all(20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.topLeft,
              ),
              onPressed: null,
              onLongPress: () {
                print("hola");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: 380,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Order N° ${order.id}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      child: Text(
                        relativeDate,
                        style: const TextStyle(
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      child: Text(
                        "\$ ${order.totalPrice}",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 20,
                      child: Text(
                        isDelivered,
                        style: TextStyle(
                          color: colorDelivered,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
    }

    return orders;
  }
}
