import 'package:flutter/material.dart';

class BasicFormField extends StatelessWidget {
  const BasicFormField({
    super.key,
    required this.textController,
    this.obscureText = false,
  });
  final bool obscureText;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      obscureText: obscureText,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
          hintText: 'Enter valid username'),
    );
  }
}
