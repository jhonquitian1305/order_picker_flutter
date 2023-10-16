import 'dart:convert';
import 'dart:io';

import 'package:order_picker/domain/entities/create_product_dto.dart';
import 'package:order_picker/domain/entities/new_product.dart';
import 'package:order_picker/domain/entities/product.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/screens/image_service.dart';
import 'package:http/http.dart' as http;

Future<Product> createProduct(NewProduct newProduct) async {
  if (!newProduct.isValid()) throw Exception('Image is required');
  String imageUrl = await uploadImage(newProduct.image ?? File(''));
  var productDto = CreateProductDTO(
    name: newProduct.name ?? '',
    imageUrl: imageUrl,
    price: newProduct.price ?? 0,
    amount: newProduct.amount ?? 0,
  );
  final uri = Uri.parse('$url/products');
  final response = await http.post(
    uri,
    body: jsonEncode(productDto),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 201) {
    final productJson = jsonDecode(response.body);
    return Product.fromJson(productJson);
  } else {
    throw Exception(
        'Failed to create product, status code: ${response.statusCode}');
  }
}
