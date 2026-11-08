import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color deepNavy = Color(0xFF0A192F);
  static const Color royalGold = Color(0xFFC5A059);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color surfaceDark = Color(0xFF112240);
  static const Color textLight = Color(0xFFE6F1FF);
  static const Color textDark = Color(0xFF0A192F);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color errorRed = Color(0xFFC62828);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.royalGold,
      scaffoldBackgroundColor: AppColors.offWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.royalGold,
        secondary: AppColors.deepNavy,
        surface: Colors.white,
        background: AppColors.offWhite,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepNavy,
        foregroundColor: AppColors.royalGold,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.royalGold,
      scaffoldBackgroundColor: AppColors.deepNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.royalGold,
        secondary: AppColors.royalGold,
        surface: AppColors.surfaceDark,
        background: AppColors.deepNavy,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.surfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepNavy,
        foregroundColor: AppColors.royalGold,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
