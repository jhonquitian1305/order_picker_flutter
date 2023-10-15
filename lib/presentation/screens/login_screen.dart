import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/providers/secure_storage_provider.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';

import '../widgets/basic_form_button.dart';
import '../widgets/basic_form_field.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(storageProvider).deleteAll();

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
                  bool logged = await login(
                      emailController.text, passwordController.text, ref);
                  print(await ref
                      .watch(storageProvider.notifier)
                      .state
                      .read(key: "jwt"));
                  if (context.mounted) {
                    logged
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OrdersView()))
                        : showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('Usuario o contraseña incorrecto'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }
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

Future<bool> login(String email, String password, WidgetRef ref) async {
  try {
    Response response = await post(Uri.parse('$url/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 200) {
      print("success");
      var token = jsonDecode(response.body.toString())['token'];
      await ref
          .read(storageProvider.notifier)
          .state
          .write(key: 'jwt', value: token);
      return true;
    } else {
      print('failed');
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}
