import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFB00020);
  static const Color white = Color(0xFFffffff);
  static const Color transparent = Colors.transparent;

  static const LinearGradient gradientBtn = LinearGradient(
    colors: [
      Color(0xFFE45625),
      Color(0xFFF87E3A),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient gradientBackground = LinearGradient(

      colors: [
        Color(0xFF0E0533),
        Color(0xFF3E1471),
        Color(0xFF4D1E6D),


      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
  );


}