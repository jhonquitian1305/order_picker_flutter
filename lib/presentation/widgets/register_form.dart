import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/widgets/button.dart';
import 'package:order_picker/presentation/widgets/rounded_text_field.dart';
import 'package:tabler_icons/tabler_icons.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key, required this.userRole});

  final Role userRole;
  final TextEditingController dniController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  "Enter your information",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              controller: dniController,
              labelText: "DNI",
              hintText: "Enter your DNI.",
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              controller: fullNameController,
              labelText: "Full name",
              hintText: "Enter your full name.",
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              controller: emailController,
              labelText: "Email",
              hintText: "Enter your email.",
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              controller: passwordController,
              obscureText: true,
              labelText: "Password",
              hintText: "Enter your password.",
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              controller: addressController,
              labelText: "Address",
              hintText: "Enter your address.",
            ),
            const SizedBox(height: 10),
            RoundedTextField(
              controller: phoneController,
              labelText: "Phone",
              hintText: "Enter your phone number.",
            ),
            const SizedBox(height: 10),
            Button(
                child: const Text("Register"),
                onPressed: () async {
                  bool logged = await register(
                      dni: dniController.text,
                      fullName: fullNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                      role: userRole);
                  if (context.mounted) {
                    logged
                        ? customAlertDialog(
                            context: context,
                            title: "Success",
                            content: "You have been registered successfully.",
                            icon: const Icon(
                              TablerIcons.user_check,
                              size: 50,
                              color: Color.fromRGBO(180, 180, 180, 1.0),
                            ),
                          )
                        : customAlertDialog(
                            context: context,
                            title: "Error",
                            content: "Check your data and try again.",
                            icon: const Icon(
                              TablerIcons.user_x,
                              size: 50,
                              color: Color.fromRGBO(180, 180, 180, 1.0),
                            ),
                          );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

Future<bool> register({
  required String dni,
  required String fullName,
  required String email,
  required String password,
  required String address,
  required String phone,
  required Role role,
}) async {
  try {
    UserDTO userDTO = UserDTO(
        dni: dni,
        fullName: fullName,
        email: email,
        password: password,
        address: address,
        phone: phone,
        role: role);
    Response response = await post(Uri.parse('$url/users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userDTO.toJson()));
    return response.statusCode == 201;
  } catch (e) {
    rethrow;
  }
}

Future<String?> customAlertDialog(
    {required BuildContext context,
    required String title,
    required String content,
    Icon? icon}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          Text(
            content,
          ),
        ],
      ),
      actions: <Widget>[
        Button(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
