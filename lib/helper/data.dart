import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Record {
  final LinearGradient linearGradient;
  final FaIcon faIcon;
  final String name;
  final String date;
  final String amount;

  Record(this.name, this.date, this.amount, this.linearGradient, this.faIcon);
}

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
Map<String, Widget> iconMap = {
  'Food': Image.asset(
    'assets/food.png',
    fit: BoxFit.contain,
    width: 30,
    height: 30,
  ),
  'Shopping': Image.asset(
    'assets/shopping.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Education': Image.asset(
    'assets/education.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Transport': Image.asset(
    'assets/transport.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Health': Image.asset(
    'assets/health.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Entertainment': Image.asset(
    'assets/entertainment.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Home': Image.asset(
    'assets/house.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Others': Image.asset(
    'assets/other.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Saving':Image.asset(
    'assets/salary.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Salary': Image.asset(
    'assets/salary.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
  'Initial Balance':Image.asset(
    'assets/salary.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
  ),
};

Map<String, Widget> iconType = {
  'Income': Icon(CupertinoIcons.up_arrow, size: 20, color: Colors.green),
  'Expense': Icon(CupertinoIcons.down_arrow, size: 20, color: Colors.red),
};

Map<String, LinearGradient> colorMap = {
  'Food': LinearGradient(
    colors: [
      Colors.pinkAccent.withValues(alpha: .0),
      Colors.pinkAccent.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Shopping': LinearGradient(
    colors: [
      Colors.purple.withValues(alpha: 1.0),
      Colors.purple.withValues(alpha: 0.85),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Education': LinearGradient(
    colors: [
      Colors.green.withValues(alpha: 1.0),
      Colors.green.withValues(alpha: 0.85),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Transport': LinearGradient(
    colors: [
      Colors.brown.withValues(alpha: 1.0),
      Colors.brown.withValues(alpha: 0.85),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Health': LinearGradient(
    colors: [
      Colors.red.withValues(alpha: 1.0),
      Colors.red.withValues(alpha: 0.85),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Entertainment': LinearGradient(
    colors: [
      Colors.blueGrey.withValues(alpha: 1.0),
      Colors.blueGrey.withValues(alpha: 0.85),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Home': LinearGradient(
    colors: [
      Colors.lightBlueAccent.withValues(alpha: 1.0),
      Colors.lightBlueAccent.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Others': LinearGradient(
    colors: [
      Colors.deepPurpleAccent.withValues(alpha: 1.0),
      Colors.deepPurpleAccent.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Saving': LinearGradient(
    colors: [
      Colors.greenAccent.withValues(alpha: 1.0),
      Colors.greenAccent.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Salary': LinearGradient(
    colors: [
      Colors.lightBlueAccent.withValues(alpha: 1.0),
      Colors.lightBlueAccent.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  'Initial Balance': LinearGradient(
    colors: [
      Colors.lightBlueAccent.withValues(alpha: 1.0),
      Colors.lightBlueAccent.withValues(alpha: 0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
};
