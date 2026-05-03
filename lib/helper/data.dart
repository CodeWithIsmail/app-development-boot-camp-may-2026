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
  'Travel',
  'Others',
];
Map<String, Widget> iconMap = {
  'Food': FaIcon(FontAwesomeIcons.burger, color: Colors.white),
  'Shopping': FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
  'Education': FaIcon(FontAwesomeIcons.book, color: Colors.white),
  'Transport': FaIcon(FontAwesomeIcons.bus, color: Colors.white),
  'Health': Icon(Icons.medical_information_rounded, color: Colors.white),
  'Travel': FaIcon(FontAwesomeIcons.plane, color: Colors.white),
  'Home': FaIcon(FontAwesomeIcons.house, color: Colors.white),
  'Others': FaIcon(FontAwesomeIcons.moneyBill, color: Colors.white),
  'Saving': FaIcon(FontAwesomeIcons.buildingColumns, color: Colors.white),
  'Salary': FaIcon(FontAwesomeIcons.dollarSign, color: Colors.white),
  'Initial Balance': FaIcon(FontAwesomeIcons.dollarSign, color: Colors.white),
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
  'Travel': LinearGradient(
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
