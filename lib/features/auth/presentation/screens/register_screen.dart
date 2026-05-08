import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/constants.dart';
import 'package:mexpense/core/widgets/widgets.dart';
import 'package:mexpense/features/auth/presentation/providers/providers.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? togglefunction;

  const RegisterScreen(this.togglefunction, {super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conpass = TextEditingController();
  TextEditingController initialBal = TextEditingController();

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
        AppToast('All fields must be filled').showToast();
        return;
      }

      if (!_isValidUsername(uname.text)) {
        AppToast('Username must contain only letters and numbers').showToast();
        return;
      }

      if (pass.text.length < 6) {
        AppToast('Password must be at least 6 characters').showToast();
        return;
      }

      if (pass.text != conpass.text) {
        AppToast('Passwords don\'t match').showToast();
        return;
      }

      final username = uname.text.toLowerCase();
      final double initBal = double.parse(initialBal.text);
      await context.read<UserProvider>().signUp(
        name: name.text,
        username: username,
        password: pass.text,
        initialBalance: initBal,
        
      );
    } on Exception {
      AppToast('Username already exists. Try another username.').showToast();
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
                      CustomTextField('Name', name, false, 1),
                      SizedBox(height: 20),
                      CustomTextField('Username', uname, false, 1),
                      SizedBox(height: 20),
                      CustomTextField('Password', pass, true, 1),
                      SizedBox(height: 20),
                      CustomTextField('Confirm Password', conpass, true, 1),
                      SizedBox(height: 20),
                      CustomTextField('Current balance', initialBal, true, 0),
                      SizedBox(height: 40),
                      PrimaryButton(regi, 'Register'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?  ',
                            style: TextStyle(color: Colors.white),
                          ),
                          AppTextButton(
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
