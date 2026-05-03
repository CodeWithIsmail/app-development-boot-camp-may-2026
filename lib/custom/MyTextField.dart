import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hint;
  TextEditingController controll;
  bool obscure;
  int keyboardtype;

  MyTextField(this.hint, this.controll, this.obscure, this.keyboardtype);

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
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscure,
    );
  }
}
