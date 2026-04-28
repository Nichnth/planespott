import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(AppColors.primary),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(AppColors.surface),
        foregroundColor: Color(AppColors.textPrimary),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.textPrimary),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(AppColors.primary),
        foregroundColor: Color(AppColors.surface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(AppColors.primary),
          foregroundColor: Color(AppColors.surface),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.lg,
            vertical: AppSizing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.borderRadiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.md,
            vertical: AppSizing.sm,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(AppColors.primary),
          side: BorderSide(color: Color(AppColors.primary)),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.lg,
            vertical: AppSizing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.borderRadiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(AppColors.background),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizing.md,
          vertical: AppSizing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.borderRadiusMd),
          borderSide: BorderSide(color: Color(AppColors.border)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.borderRadiusMd),
          borderSide: BorderSide(color: Color(AppColors.border)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.borderRadiusMd),
          borderSide: BorderSide(color: Color(AppColors.primary), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.borderRadiusMd),
          borderSide: BorderSide(color: Color(AppColors.error)),
        ),
        labelStyle: GoogleFonts.inter(
          color: Color(AppColors.textSecondary),
        ),
        hintStyle: GoogleFonts.inter(
          color: Color(AppColors.textSecondary),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.borderRadiusLg),
        ),
        color: Color(AppColors.surface),
      ),
      scaffoldBackgroundColor: Color(AppColors.background),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(AppColors.primary),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }
}

