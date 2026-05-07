import 'package:flutter/material.dart';
import 'package:mexpense/core/constants/constants.dart';

class BalanceShowGroup extends StatelessWidget {
  final IconData iconName;
  final Color iconColor;
  final String text;
  final int amount;

  const BalanceShowGroup(
    this.iconName,
    this.iconColor,
    this.text,
    this.amount, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          child: Icon(size: 20, iconName, color: iconColor),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: titleTextStyle),
            Text(amount.toString(), style: valueTextStyle),
          ],
        ),
      ],
    );
  }
}
