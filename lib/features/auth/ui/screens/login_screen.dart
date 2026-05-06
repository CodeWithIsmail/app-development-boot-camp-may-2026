import 'package:flutter/material.dart';
import 'package:mexpense/features/auth/providers/auth_provider.dart';
import 'package:mexpense/widgets/widgets.dart';
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
    final authProvider = context.read<AuthProvider>();
    await authProvider.signIn(
      username: uname.text.toLowerCase(),
      password: pass.text,
    );
    if (authProvider.error == null) {
      // Navigation handled by app.dart
    } else {
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
