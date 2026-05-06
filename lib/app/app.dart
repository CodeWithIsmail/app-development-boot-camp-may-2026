import 'package:flutter/material.dart';
import 'package:mexpense/features/auth/providers/auth_provider.dart';
import 'package:mexpense/features/auth/ui/screens/login_screen.dart';
import 'package:mexpense/features/transactions/providers/transaction_provider.dart';
import 'package:mexpense/features/transactions/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'MExpense',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.currentUserId != null) {
              // Set user in transaction provider
              context.read<TransactionProvider>().setCurrentUser(
                auth.currentUserId!,
              );
              return const HomeScreen();
            } else {
              return LoginScreen(null);
            }
          },
        ),
      ),
    );
  }
}
