import 'dart:io';

import 'package:flutter/material.dart';
import 'package:order_picker/domain/entities/new_product.dart';
import 'package:order_picker/presentation/screens/create_product_service.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/image_filed.dart';
import 'package:order_picker/presentation/widgets/rounded_text_field.dart';

class NewProductDemo extends StatefulWidget {
  const NewProductDemo({super.key});

  @override
  _NewProductDemoState createState() => _NewProductDemoState();
}

class _NewProductDemoState extends State<NewProductDemo> {
  NewProduct newProduct = NewProduct();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add a new product ✨'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(children: [
            ImageField(
              onChange: (File? image) {
                newProduct.image = image;
              },
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              hintText: 'Enter valid product name',
              labelText: 'name',
              onChanged: (value) {
                newProduct.name = value;
              },
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              hintText: 'Enter product price',
              labelText: 'price',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newProduct.price = double.parse(value);
              },
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              hintText: 'Enter de product quantity',
              labelText: 'amount',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newProduct.amount = int.parse(value);
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  child: const Text(
                    'Create Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () async {
                    if (!validNewProduct()) {
                      return;
                    }
                    await createProduct(newProduct);
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  bool validNewProduct() {
    return newProduct.name != null &&
        newProduct.name!.isNotEmpty &&
        newProduct.price != null &&
        newProduct.amount != null &&
        newProduct.image != null;
  }
}
