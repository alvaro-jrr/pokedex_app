import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Colors.blue;

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor.shade100,
    ),
  );
}
