import 'package:flutter/material.dart';
import 'package:order_picker/config/theme/app_theme.dart';
import 'package:order_picker/presentation/screens/create_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme().getTheme(),
      home: const NewProductDemo(),
    );
  }
}
