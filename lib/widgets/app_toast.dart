import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  String text;

  AppToast(this.text);

  void showToast() {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
