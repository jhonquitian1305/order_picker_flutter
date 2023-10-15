import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final bool expanded;

  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Expanded(
        child: baseButton(),
      );
    }
    return baseButton();
  }

  Widget baseButton() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 50, minHeight: 50),
      child: ElevatedButton(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999))),
        ),
        onPressed: onPressed,
        child: Center(child: child),
      ),
    );
  }
}
