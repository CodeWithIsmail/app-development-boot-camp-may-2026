
import 'package:flutter/material.dart';
import 'package:mexpense/helper/constants.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

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
