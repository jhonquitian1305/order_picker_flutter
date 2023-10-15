import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';
import 'package:order_picker/presentation/widgets/basic_form_button.dart';
import 'package:order_picker/presentation/widgets/basic_form_field.dart';

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
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: BasicFormField(
                textController: dniController,
                labelText: "DNI",
                hintText: "Enter your DNI.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: BasicFormField(
                textController: fullNameController,
                labelText: "Full name",
                hintText: "Enter your full name.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: BasicFormField(
                textController: emailController,
                labelText: "Email",
                hintText: "Enter your email.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: BasicFormField(
                textController: passwordController,
                obscureText: true,
                labelText: "Password",
                hintText: "Enter your password.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: BasicFormField(
                textController: addressController,
                labelText: "Address",
                hintText: "Enter your address.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: BasicFormField(
                textController: phoneController,
                labelText: "Phone",
                hintText: "Enter your phone number.",
              ),
            ),
            BasicFormButton(
                text: "Register",
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
                            context, "", "Te has registrado exitosamente.")
                        : customAlertDialog(context, "Error",
                            "Revisa que hayas ingresado todos los campos correctamente.");
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
    BuildContext context, String title, String content) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(
        content,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ),
  );
}
