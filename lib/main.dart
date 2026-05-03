import 'package:flutter/material.dart';
import 'package:mexpense/helper/auth_identify.dart';
import 'package:mexpense/helper/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MExpense',
      theme: ThemeData(colorScheme: colorList),
      home: AuthWrapper(),
    );
  }
}
