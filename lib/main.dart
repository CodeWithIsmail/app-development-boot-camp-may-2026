import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/constants.dart';
import 'package:mexpense/features/auth/presentation/providers/providers.dart'
    as auth;
import 'package:mexpense/features/auth/presentation/widgets/auth_wrapper.dart';
import 'package:mexpense/features/dashboard/presentation/providers/providers.dart'
    as dashboard;
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
        ChangeNotifierProvider(create: (_) => auth.UserProvider()),
        ChangeNotifierProxyProvider<
          auth.UserProvider,
          dashboard.ExpenseProvider
        >(
          create: (_) => dashboard.ExpenseProvider(),
          update: (_, userProvider, expenseProvider) {
            final provider = expenseProvider ?? dashboard.ExpenseProvider();
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
