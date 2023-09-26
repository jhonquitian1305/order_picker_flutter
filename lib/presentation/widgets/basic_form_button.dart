import 'package:flutter/material.dart';

class BasicFormButton extends StatelessWidget {
  const BasicFormButton(
      {super.key, required this.text, required this.onPressed});
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 360,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
