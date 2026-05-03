import 'package:flutter/material.dart';
import 'package:mexpense/helper/constants.dart';
import 'package:mexpense/screens/home_screen.dart';
import 'package:mexpense/services/auth_service.dart';
import 'package:mexpense/services/local_expense_service.dart';
import 'package:mexpense/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? togglefunction;

  const LoginScreen(this.togglefunction, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();

  void login() async {
    try {
      final username = uname.text.toLowerCase();
      await AuthService().signIn(username: username, password: pass.text);
      final localExpenseService = LocalExpenseService(username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(localExpenseService)),
      );
    } on Exception {
      AppToast('Invalid credential. Login failed.').showToast();
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
                AppLogo(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      CustomTextField('Username', uname, false, 1),
                      SizedBox(height: 20),
                      CustomTextField('Password', pass, true, 1),
                      SizedBox(height: 40),
                      PrimaryButton(login, 'Login'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?  ',
                            style: TextStyle(color: Colors.white),
                          ),
                          AppTextButton(
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
