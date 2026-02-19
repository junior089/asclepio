import 'package:flutter/material.dart';
import 'asclepio_theme.dart';

/// Design System Asclépio V2
/// Wrapper sobre AsclepioTheme para compatibilidade com código legado.
/// Todas as cores delegam para AsclepioTheme onde possível.
class AppTheme {
  AppTheme._();

  // ── Cores principais (delegam para AsclepioTheme) ────────────────────────
  static const Color primary = AsclepioTheme.primary;
  static const Color primaryDark = Color(0xFFC62828);
  static const Color primaryLight = Color(0xFFFF6F60);
  static const Color accent = AsclepioTheme.secondary;

  // ── Cores de Categorias ──────────────────────────────────────────────────
  static const Color water = Color(0xFF2196F3);
  static const Color steps = Color(0xFFE53935);
  static const Color weight = Color(0xFF43A047);
  static const Color sleep = Color(0xFF5E35B1);

  // ── Superfícies ────────────────────────────────────────────────────────────
  static const Color background = AsclepioTheme.backgroundLight;
  static const Color surface = AsclepioTheme.surfaceLight;
  static const Color surfaceVariant = Color(0xFFEEEEEE);

  // ── Texto ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = AsclepioTheme.textPrimaryLight;
  static const Color textSecondary = AsclepioTheme.textSecondaryLight;
  static const Color textLight = Color(0xFFBDBDBD);

  // ── Gradientes ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = AsclepioTheme.primaryGradient;

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Cores de categorias (Anéis) ────────────────────────────────────────────
  static const Color moveRing = Color(0xFFE53935);
  static const Color exerciseRing = Color(0xFF66BB6A);
  static const Color standRing = Color(0xFF42A5F5);

  // ── Sombras ────────────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      );

  // ── Temas (delegam para AsclepioTheme) ────────────────────────────────────
  static ThemeData get light => AsclepioTheme.light;
  static ThemeData get dark => AsclepioTheme.dark;
}
