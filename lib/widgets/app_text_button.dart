import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final void Function()? function;
  final String text;
  final Color textcolor;
  final double fontsize;
  final bool bold;

  const AppTextButton(
    this.text,
    this.textcolor,
    this.fontsize,
    this.bold,
    this.function, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Text(
        text,
        style: TextStyle(
          color: textcolor,
          fontSize: fontsize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
