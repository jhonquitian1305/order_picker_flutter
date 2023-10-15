import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const RoundedTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 50),
      child: TextField(
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            labelStyle: const TextStyle(color: Color.fromRGBO(85, 85, 85, 1)),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(85, 85, 85, 1)),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            labelText: labelText,
            hintText: hintText),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}
