import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? function;
  final String text;

  const PrimaryButton(this.function, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text, style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }
}
