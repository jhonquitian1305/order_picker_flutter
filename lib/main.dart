import 'package:flutter/material.dart';
import 'package:order_picker/config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:order_picker/presentation/screens/login_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme().getTheme(),
      home: LoginScreen(appTitle: "Order Picker"),
    );
  }
}
