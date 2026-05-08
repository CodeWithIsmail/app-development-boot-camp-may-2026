import 'dart:math';

import 'package:flutter/material.dart';

final appNameTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(blurRadius: 10.0, color: Colors.black26, offset: Offset(3.0, 3.0)),
  ],
);

const gradientColor1 = Color(0xFF71B280);
const gradientColor2 = Color(0xFF134E5E);
const List<Color> gradientColors = [gradientColor1, gradientColor2];

final gradient = LinearGradient(
  colors: gradientColors,
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

final colorList = ColorScheme.light(
  surface: Colors.grey.shade100,
  onSurface: Colors.black,
  primary: gradientColor1,
  secondary: gradientColor2,
);

const welcomeTextStyle = TextStyle(
  color: gradientColor2,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

const nameTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const titleTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 10,
  // fontWeight: FontWeight.bold,
);

const valueTextStyle = TextStyle(color: Colors.white, fontSize: 20);

const netBalTextStyle = TextStyle(color: Colors.white, fontSize: 15);

const balTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.bold,
);

const addTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

final barGradient = LinearGradient(
  colors: gradientColors,
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

final barChartLeftStyle = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.bold,
  fontSize: 14,
);
final barChartBottomStyle = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.bold,
  fontSize: 7,
);

const customGradient = LinearGradient(colors: gradientColors);

const dashboardGradient = LinearGradient(
  colors: gradientColors,
  transform: GradientRotation(pi / 4),
);

final dashboardShadow = BoxShadow(
  color: Colors.grey.shade500,
  offset: Offset(5, 5),
  blurRadius: 10,
);

const expensesTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const expenseTitleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 17,
  fontWeight: FontWeight.w500,
);
const expenseValTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
const expenseDayTextStyle = TextStyle(
  color: Colors.blueGrey,
  fontSize: 15,
  fontWeight: FontWeight.w400,
);

final expenseTileDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: Colors.white,
  boxShadow: [
    BoxShadow(color: Colors.grey.shade400, offset: Offset(1, 3), blurRadius: 5),
  ],
);

const selectColor = Colors.lightBlueAccent;
const unselectColor = Colors.grey;
