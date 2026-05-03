import 'package:flutter/material.dart';
import 'package:mexpense/helper/log_or_regi.dart';
import 'package:mexpense/screens/home_screen.dart';
import 'package:mexpense/services/auth_service.dart';
import 'package:mexpense/services/database_helper.dart';
import 'package:mexpense/services/local_expense_service.dart';

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
          LocalExpenseService(displayName);
          return HomeScreen();
        } else {
          return LoginOrRegistration();
        }
      },
    );
  }
}
