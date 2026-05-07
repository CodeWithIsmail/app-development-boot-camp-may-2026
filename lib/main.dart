import 'package:flutter/material.dart';
import 'package:mexpense/helper/auth_identify.dart';
import 'package:mexpense/helper/constants.dart';
import 'package:mexpense/providers/providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, ExpenseProvider>(
          create: (_) => ExpenseProvider(),
          update: (_, userProvider, expenseProvider) {
            final provider = expenseProvider ?? ExpenseProvider();
            provider.syncUser(userProvider.currentUser?.id);
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'MExpense',
        theme: ThemeData(colorScheme: colorList),
        home: const AuthWrapper(),
      ),
    );
  }
}
