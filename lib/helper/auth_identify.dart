import 'package:flutter/material.dart';
import 'package:mexpense/helper/log_or_regi.dart';
import 'package:mexpense/providers/providers.dart';
import 'package:mexpense/screens/home_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<void> _restoreFuture;

  @override
  void initState() {
    super.initState();
    _restoreFuture = context.read<UserProvider>().restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _restoreFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (context.watch<UserProvider>().currentUser != null) {
          return const HomeScreen();
        }

        return const LoginOrRegistration();
      },
    );
  }
}
