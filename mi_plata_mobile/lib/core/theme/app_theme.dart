import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // Keeping a light theme variant, but main focus is dark mode.
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accent,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentDark,
        secondary: AppColors.accent,
        surface: Colors.white,
        error: AppColors.danger,
      ),
      fontFamily: 'Inter',
      textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accent,
      scaffoldBackgroundColor: AppColors.graphite900,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentLight,
        surface: AppColors.graphite800,
        error: AppColors.danger,
        onPrimary: AppColors.graphite900,
        onSurface: AppColors.textWhite,
      ),
      fontFamily: 'Inter',
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter').copyWith(
        bodyLarge: const TextStyle(fontFamily: 'Inter', color: AppColors.textWhite),
        bodyMedium: const TextStyle(fontFamily: 'Inter', color: AppColors.textGray400),
        titleLarge: const TextStyle(fontFamily: 'Inter', color: AppColors.textWhite, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(fontFamily: 'Inter', color: AppColors.textWhite, fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textWhite),
        titleTextStyle: TextStyle(
          color: AppColors.textWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.graphite800, // Or blur effect in UI
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textGray400,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
      cardTheme: CardThemeData(
        color: AppColors.graphite800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.graphite700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.graphite900,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.graphite800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.graphite700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.graphite700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        hintStyle: const TextStyle(color: AppColors.textGray500),
        labelStyle: const TextStyle(color: AppColors.textGray400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.graphite700,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
