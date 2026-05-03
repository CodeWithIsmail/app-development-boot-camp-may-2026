import 'package:flutter/material.dart';

class MyButtonGestureDetector extends StatelessWidget {
  void Function()? function;
  String text;

  MyButtonGestureDetector(this.function, this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: kToolbarHeight,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text, style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }
}
