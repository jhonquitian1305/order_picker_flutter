import 'package:flutter/material.dart';
import 'package:order_picker/domain/entities/user.dart';

import '../widgets/register_form.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: RegisterForm(
          userRole: Role.user,
        ));
  }
}
