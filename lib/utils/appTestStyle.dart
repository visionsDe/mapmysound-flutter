import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appFonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle regular = TextStyle(
    fontFamily: AppFonts.outfit,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle medium = TextStyle(
    fontFamily: AppFonts.outfit,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle semiBold = TextStyle(
    fontFamily: AppFonts.outfit,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle light = TextStyle(
    fontFamily: AppFonts.outfit,
    fontWeight: FontWeight.w300,
  );

  // Sizes
  static TextStyle regular14 = regular.copyWith(fontSize: 14, color: AppColors.textSecondary);
  static TextStyle regular16 = regular.copyWith(fontSize: 16);
  static TextStyle semibold18 = semiBold.copyWith(fontSize: 18);
  static TextStyle medium18 = medium.copyWith(fontSize: 18, color: AppColors.white);
  static TextStyle light14 = light.copyWith(fontSize: 14, color: AppColors.secondary);
}
