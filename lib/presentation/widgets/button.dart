import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  void Function() onPressed;
  Widget child;

  Button({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
        padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
