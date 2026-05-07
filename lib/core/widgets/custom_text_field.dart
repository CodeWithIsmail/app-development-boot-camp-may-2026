import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controll;
  final bool obscure;
  final int keyboardtype;

  const CustomTextField(
    this.hint,
    this.controll,
    this.obscure,
    this.keyboardtype, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardtype == 0
          ? TextInputType.number
          : TextInputType.emailAddress,
      controller: controll,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscure,
    );
  }
}
