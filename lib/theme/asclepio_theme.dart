import 'package:flutter/material.dart';

class AsclepioTheme {
  AsclepioTheme._();

  // ── Colors (Apple Health Inspired) ─────────────────────────────────────────
  // Clean, Medical, Premium
  static const Color primary = Color(0xFFFF2D55); // Apple Health Red
  static const Color secondary = Color(0xFF5856D6); // iOS Purple
  static const Color tertiary = Color(0xFFFF9500); // iOS Orange

  static const Color backgroundLight = Color(0xFFF2F2F7); // iOS System Gray 6
  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color backgroundDark = Color(0xFF000000); // Pure Black
  static const Color surfaceDark = Color(0xFF1C1C1E); // iOS System Gray 6 Dark

  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0xFF8E8E93);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFAEAEB2);

  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF2D55), Color(0xFFFF375F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF9500), Color(0xFFFF3B30)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadows ────────────────────────────────────────────────────────────────
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowNeon => [
        BoxShadow(
          color: primary.withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // ── Typography ─────────────────────────────────────────────────────────────
  static TextTheme _textTheme(bool isDark) {
    final color = isDark ? textPrimaryDark : textPrimaryLight;
    final secondary = isDark ? textSecondaryDark : textSecondaryLight;

    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'Roboto', // System font preferred usually
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.4,
          color: color),
      displayMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.4,
          color: color),
      displaySmall: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: color),
      headlineMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.4, // Tight tracking
          color: color),
      bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.4,
          letterSpacing: -0.4,
          color: color),
      bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: secondary),
      labelLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: color),
    );
  }

  // ── Themes ─────────────────────────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surfaceLight,
        error: error,
        onSurface: textPrimaryLight,
      ),
      textTheme: _textTheme(false),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
            color: textPrimaryLight,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5),
        iconTheme: IconThemeData(color: textPrimaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: textPrimaryLight, // Black button on light mode
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: textPrimaryLight, width: 2)),
        labelStyle: const TextStyle(color: textSecondaryLight),
        hintStyle: const TextStyle(color: textSecondaryLight),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surfaceDark,
        error: error,
        onSurface: textPrimaryDark,
      ),
      textTheme: _textTheme(true),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
            color: textPrimaryDark,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5),
        iconTheme: IconThemeData(color: textPrimaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black, // Volt button, black text
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primary, width: 2)),
        labelStyle: const TextStyle(color: textSecondaryDark),
        hintStyle: const TextStyle(color: textSecondaryDark),
      ),
    );
  }
}
