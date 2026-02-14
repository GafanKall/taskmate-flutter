import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF38BDF8); // Updated to #38BDF8
  static const Color primaryDark = Color(0xFF0EA5E9); // Adjust dark variant

  static const Color backgroundLight = Color(0xFFF3F4F6); // Updated to #F3F4F6
  static const Color backgroundDark = Color(0xFF0F172A);

  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  static const Color textLight = Color(
    0xFF0F172A,
  ); // Updated to match slate-900
  static const Color textDark = Color(0xFFF1F5F9); // Updated to match slate-100

  static const Color subTextLight = Color(0xFF64748B); // slate-500
  static const Color subTextDark = Color(0xFF94A3B8); // slate-400

  static const Color inputBgLight = Color(0xFFF9FAFB);
  static const Color inputBgDark = Color(0xFF0F172A);

  static const Color borderLight = Color(0xFFE2E8F0); // slate-200
  static const Color borderDark = Color(0xFF1E293B); // slate-800
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.cardLight,
        onSurface: AppColors.textLight,
        outline: AppColors.borderLight,
        surfaceContainerHighest: AppColors.inputBgLight, // Using for input bg
        onSurfaceVariant: AppColors.subTextLight, // Using for subtext/hint
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
        bodyLarge: GoogleFonts.inter(color: AppColors.textLight),
        bodyMedium: GoogleFonts.inter(color: AppColors.subTextLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBgLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: TextStyle(color: AppColors.subTextLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.cardDark,
        onSurface: AppColors.textDark,
        outline: AppColors.borderDark,
        surfaceContainerHighest: AppColors.inputBgDark,
        onSurfaceVariant: AppColors.subTextDark,
      ),
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(
            ThemeData.dark().textTheme,
          ).copyWith(
            displayLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            displayMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            bodyLarge: GoogleFonts.inter(color: AppColors.textDark),
            bodyMedium: GoogleFonts.inter(color: AppColors.subTextDark),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBgDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: TextStyle(color: AppColors.subTextDark),
      ),
    );
  }
}
