import 'package:flutter/material.dart';
import 'package:mexpense/features/auth/presentation/screens/login_screen.dart';
import 'package:mexpense/features/auth/presentation/screens/register_screen.dart';

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
      return LoginScreen(togglepage);
    } else {
      return RegisterScreen(togglepage);
    }
  }
}
