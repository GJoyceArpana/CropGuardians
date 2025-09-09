import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle companyName = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGray,
    letterSpacing: -0.5,
  );

  static const TextStyle tagline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGreen,
    letterSpacing: 0.3,
  );
}