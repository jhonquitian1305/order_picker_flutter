import 'package:flutter/material.dart';

class BasicFormField extends StatelessWidget {
  const BasicFormField({
    super.key,
    required this.textController,
    this.obscureText = false,
    this.labelText = " ",
    this.hintText = " ",
  });
  final bool obscureText;
  final TextEditingController textController;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      obscureText: obscureText,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText),
    );
  }
}
