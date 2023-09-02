import 'package:flutter/material.dart';

class Palette {
  static const Color primary = Color(0xFF478FFD);
  static const Color orange = Colors.orange;
}

class ThemeApp {
  static lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Palette.primary),
      useMaterial3: true,
    );
  }
}
