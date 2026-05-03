import 'package:flutter/material.dart';

final appNameTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(blurRadius: 10.0, color: Colors.black26, offset: Offset(3.0, 3.0)),
  ],
);

final gradient = LinearGradient(
  colors: [Color(0xFF355C7D), Color(0xFF6C5B7B), Color(0xFFC06C84)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final colorList = ColorScheme.light(
  surface: Colors.grey.shade100,
  onSurface: Colors.black,
  primary: Color(0xFF355C7D),
  secondary: Color(0xFF6C5B7B),
  tertiary: Color(0xFFC06C84),
);
