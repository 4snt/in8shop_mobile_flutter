import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  /// 🌞 Tema Claro
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: AppColors.surfaceLight,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      onSurface: AppColors.foregroundLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      outline: AppColors.borderLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.primaryLight,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primaryLight),
      titleTextStyle: TextStyle(
        color: AppColors.primaryLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.mutedLight,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    cardColor: AppColors.surfaceLight,
    dividerColor: AppColors.borderLight,
    useMaterial3: true,
  );

  /// 🌚 Tema Escuro
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: AppColors.surfaceDark,
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      onSurface: AppColors.foregroundDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      outline: AppColors.borderDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.primaryDark,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primaryDark),
      titleTextStyle: TextStyle(
        color: AppColors.primaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.mutedDark,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    cardColor: AppColors.surfaceDark,
    dividerColor: AppColors.borderDark,
    useMaterial3: true,
  );
}
