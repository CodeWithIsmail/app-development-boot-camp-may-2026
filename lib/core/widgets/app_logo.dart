import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/constants.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('images/moneymate.png', width: 100, height: 100),
        SizedBox(height: 20),
        Text('MoneyMate', style: appNameTextStyle),
        SizedBox(height: 40),
      ],
    );
  }
}
