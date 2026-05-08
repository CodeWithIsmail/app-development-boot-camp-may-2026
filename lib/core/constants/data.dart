import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<String> category = [
  'Shopping',
  'Food',
  'Education',
  'Home',
  'Transport',
  'Health',
  'Entertainment',
  'Others',
];

Map<String, String> iconMap = {
  'Food': 'assets/images/food.png',
  'Shopping': 'assets/images/shopping.png',
  'Education': 'assets/images/education.png',
  'Transport': 'assets/images/transport.png',
  'Health': 'assets/images/health.png',
  'Entertainment': 'assets/images/entertainment.png',
  'Home': 'assets/images/home.png',
  'Others': 'assets/images/other.png',
  'Saving': 'assets/images/saving.png',
  'Salary': 'assets/images/salary.png',
  'Initial Balance': 'assets/images/initial.png',
};

Map<String, Widget> iconType = {
  'Income': Icon(CupertinoIcons.up_arrow, size: 20, color: Colors.green),
  'Expense': Icon(CupertinoIcons.down_arrow, size: 20, color: Colors.red),
};

Map<String, Color> colorMap = {
  'Food': Colors.orange,
  'Shopping': Colors.purple,
  'Education': Colors.green,
  'Transport': Colors.brown,
  'Health': Colors.lime.shade800,
  'Entertainment': Colors.deepPurple,
  'Home': Colors.lightBlue,
  'Others': Colors.blueGrey,
};
