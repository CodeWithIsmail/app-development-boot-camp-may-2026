import 'package:flutter/material.dart';
import 'package:mexpense/features/auth/data/repositories/auth_service.dart';
import 'package:mexpense/features/transactions/data/repositories/local_expense_service.dart';
import 'package:mexpense/features/transactions/ui/screens/home_screen.dart';
import 'package:mexpense/helper/log_or_regi.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: () async {
        final userId = await AuthService().getCurrentUserId();
        if (userId == null) return null;
        final db = DatabaseHelper();
        final user = await db.getUserById(userId);
        return (user != null && user['username'] != null)
            ? user['username'] as String
            : userId.toString();
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          final displayName = snapshot.data!;
          final localExpenseService = LocalExpenseService(displayName);
          return HomeScreen(localExpenseService);
        } else {
          return LoginOrRegistration();
        }
      },
    );
  }
}
