import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:order_picker/presentation/providers/secure_storage_provider.dart';
import 'package:order_picker/presentation/screens/default_screen.dart';

import '../widgets/basic_form_button.dart';
import '../widgets/basic_form_field.dart';

class LoginDemo extends ConsumerWidget {
  LoginDemo({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  "Welcome to Order Picker",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: BasicFormField(
                textController: emailController,
                labelText: "Username",
                hintText: "Enter your username.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: BasicFormField(
                textController: passwordController,
                obscureText: true,
                labelText: "Password",
                hintText: "Enter your password.",
              ),
            ),
            BasicFormButton(
                text: "Log In",
                onPressed: () async {
                  await login(
                      emailController.text, passwordController.text, ref);
                  print(await ref
                      .watch(storageProvider.notifier)
                      .state
                      .read(key: "jwt"));
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DefaultScreen()));
                }),
            BasicFormButton(
              text: "Register",
              onPressed: () => print("register"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> login(String email, String password, WidgetRef ref) async {
  try {
    Response response = await post(
        Uri.parse('http://my_ip:8080/api/order-picker/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 200) {
      print("success");
      var token = jsonDecode(response.body.toString())['token'];
      await ref
          .read(storageProvider.notifier)
          .state
          .write(key: 'jwt', value: token);
    } else {
      print('failed');
    }
  } catch (e) {
    print(e.toString());
  }
}
