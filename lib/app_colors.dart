import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primaryRed = Color(0xFFE32127);
  static const Color gradientStartRed = Color(0xFFE32127);
  static const Color gradientEndOrange = Color(0xFFFF6238);

  // Backgrounds & Neutrals
  static const Color white = Colors.white;
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color darkPill = Color(0xFF2C2C2E);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;

  // Accents
  static const Color surveyBannerBg = Color(0xFFEBF5FB);
  static const Color surveyBannerBorder = Color(0xFFBFDBFE);
  static const Color surveyBannerText = Color(0xFF1E3A8A);
  static const Color linkBlue = Color(0xFF1E88E5);

  // Tags & status
  static const Color tagSuspendBg = Color(0xFFFFEBEE);
  static const Color tagSuspendText = Color(0xFFD32F2F);
  static const Color tagPerformanceBg = Color(0xFFE8F5E9);
  static const Color tagPerformanceText = Color(0xFF2E7D32);
  static const Color tagSystemBg = Color(0xFFEDE7F6);
  static const Color tagSystemText = Color(0xFF5E35B1);

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [gradientStartRed, gradientEndOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient promoRedGradient = LinearGradient(
    colors: [Color(0xFFE32127), Color(0xFFD0171D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
