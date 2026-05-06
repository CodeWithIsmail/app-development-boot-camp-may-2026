import 'package:flutter/material.dart';
import 'package:mexpense/features/auth/providers/auth_provider.dart';
import 'package:mexpense/features/transactions/ui/screens/home_screen.dart';
import 'package:mexpense/helper/log_or_regi.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.currentUserId != null) {
          return const HomeScreen();
        } else {
          return const LoginOrRegistration();
        }
      },
    );
  }
}
