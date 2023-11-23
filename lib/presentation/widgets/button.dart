import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

var styles = {
  ButtonType.primary: ButtonStyle(
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    ),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    backgroundColor: MaterialStateProperty.all(Colors.black),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
  ),
  ButtonType.secondary: ButtonStyle(
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    ),
    foregroundColor: MaterialStateProperty.all(Colors.black),
    backgroundColor:
        MaterialStateProperty.all(const Color.fromRGBO(225, 225, 225, 1.0)),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
  ),
};

class Button extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final ButtonType type;

  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 50, minHeight: 50),
      child: ElevatedButton(
        style: styles[type],
        onPressed: onPressed,
        child: Center(child: child),
      ),
    );
  }
}
