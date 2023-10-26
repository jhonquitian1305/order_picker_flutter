import 'package:flutter/material.dart';
import 'package:order_picker/presentation/widgets/product_list.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("New Order"),
        ),
        body: const ProductList());
  }
}
