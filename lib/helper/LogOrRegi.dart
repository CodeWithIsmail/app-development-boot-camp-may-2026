import 'package:flutter/material.dart';
import 'package:mexpense/screens/login.dart';
import 'package:mexpense/screens/register.dart';

class LoginOrRegistration extends StatefulWidget {
  const LoginOrRegistration({super.key});

  @override
  State<LoginOrRegistration> createState() => _LoginOrRegistrationState();
}

class _LoginOrRegistrationState extends State<LoginOrRegistration> {
  bool loginpage = true;

  void togglepage() {
    setState(() {
      loginpage = !loginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loginpage) {
      return Login(togglepage);
    } else {
      return Register(togglepage);
    }
  }
}
