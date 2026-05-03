// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mexpense/custom/AppNameIcon.dart';
import 'package:mexpense/custom/CustomToast.dart';
import 'package:mexpense/custom/MyButtonGestureDetector.dart';
import 'package:mexpense/custom/MyTextField.dart';
import 'package:mexpense/custom/MyTextGestureDetector.dart';
import 'package:mexpense/helper/constants.dart';
import 'package:mexpense/screens/home.dart';
import 'package:mexpense/services/auth_service.dart';
import 'package:mexpense/services/local_expense_service.dart';

class Login extends StatefulWidget {
  void Function()? togglefunction;

  Login(this.togglefunction);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();

  void login() async {
    try {
      final username = uname.text.toLowerCase();
      final userId = await AuthService().signIn(
        username: username,
        password: pass.text,
      );
      LocalExpenseService localExpenseService = LocalExpenseService(username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homescreen(),
        ),
      );
    } on Exception catch (e) {
      CustomToast('Invalid credential. Login failed.').ShowToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 55),
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      MyTextField('Username', uname, false, 1),
                      SizedBox(height: 20),
                      MyTextField('Password', pass, true, 1),
                      SizedBox(height: 40),
                      MyButtonGestureDetector(login, 'Login'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?  ',
                            style: TextStyle(color: Colors.white),
                          ),
                          MyTextGestureDetector(
                            'Register here',
                            Colors.grey.shade100,
                            14,
                            true,
                            widget.togglefunction,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
