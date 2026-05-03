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

class Register extends StatefulWidget {
  void Function()? togglefunction;

  Register(this.togglefunction);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conpass = TextEditingController();
  TextEditingController initialBal = TextEditingController();

  // Helper function to validate username format
  bool _isValidUsername(String username) {
    final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return usernameRegExp.hasMatch(username);
  }

  void regi() async {
    try {
      if (name.text.isEmpty ||
          uname.text.isEmpty ||
          pass.text.isEmpty ||
          conpass.text.isEmpty ||
          initialBal.text.isEmpty) {
        CustomToast('All fields must be filled').ShowToast();
        return;
      }

      if (!_isValidUsername(uname.text)) {
        CustomToast(
          'Username must contain only letters and numbers',
        ).ShowToast();
        return;
      }

      if (pass.text.length < 6) {
        CustomToast('Password must be at least 6 characters').ShowToast();
        return;
      }

      if (pass.text != conpass.text) {
        CustomToast('Passwords don\'t match').ShowToast();
        return;
      }

      // Use local AuthService to create user and initial balance
      final username = uname.text.toLowerCase();
      final double initBal = double.parse(initialBal.text);
      final int userId = await AuthService().signUp(
        name: name.text,
        username: username,
        password: pass.text,
        initialBalance: initBal,
      );

      LocalExpenseService localExpenseService = LocalExpenseService(username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } on Exception catch (e) {
      CustomToast('Username already exists. Try another username.').ShowToast();
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
                      MyTextField('Name', name, false, 1),
                      SizedBox(height: 20),
                      MyTextField('Username', uname, false, 1),
                      SizedBox(height: 20),
                      MyTextField('Password', pass, true, 1),
                      SizedBox(height: 20),
                      MyTextField('Confirm Password', conpass, true, 1),
                      SizedBox(height: 20),
                      MyTextField('Current balance', initialBal, true, 0),
                      SizedBox(height: 40),
                      MyButtonGestureDetector(regi, 'Register'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?  ',
                            style: TextStyle(color: Colors.white),
                          ),
                          MyTextGestureDetector(
                            'Login here',
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
