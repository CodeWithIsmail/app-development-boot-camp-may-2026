import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/constants.dart';
import 'package:mexpense/core/widgets/widgets.dart';
import 'package:mexpense/features/auth/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
      await context.read<UserProvider>().signIn(
        username: username,
        password: pass.text,
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
