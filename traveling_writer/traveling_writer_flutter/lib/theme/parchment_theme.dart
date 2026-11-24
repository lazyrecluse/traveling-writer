import 'package:flutter/material.dart';

class ParchmentTheme {
  // Base Parchment Palette
  static const Color background = Color(0xFFFBF8F2);
  static const Color cardBg = Color(0xFFF5EFE6);
  static const Color cardBorder = Color(0xFFE2D7C7);
  static const Color primaryUmber = Color(0xFF8B5A2B);
  static const Color secondaryBronze = Color(0xFFA67C52);
  static const Color inkDark = Color(0xFF2C2523);
  static const Color inkMuted = Color(0xFF6B625E);

  // Continuity Violation Colors
  static const Color alertBg = Color(0xFFFDF0ED);
  static const Color alertBorder = Color(0xFFE08D83);
  static const Color alertText = Color(0xFFB72B2B);

  // Success / Consistent Colors
  static const Color consistentBg = Color(0xFFEDF6F0);
  static const Color consistentBorder = Color(0xFFA4D4B4);
  static const Color consistentText = Color(0xFF287D47);

  // Dynamic Universe Accent Colors
  static Color getAccentColorForGenre(String? genre) {
    final g = (genre ?? '').toLowerCase();
    if (g.contains('sci-fi') || g.contains('cyber') || g.contains('space')) {
      return const Color(0xFF0284C7); // Electric Sky / Cyan
    } else if (g.contains('mystery') ||
        g.contains('thriller') ||
        g.contains('noir')) {
      return const Color(0xFF7C3AED); // Deep Royal Violet
    } else if (g.contains('horror') ||
        g.contains('grim') ||
        g.contains('gothic')) {
      return const Color(0xFF991B1B); // Blood / Crimson
    } else if (g.contains('romance') || g.contains('drama')) {
      return const Color(0xFFBE185D); // Rose / Magenta
    }
    return primaryUmber; // Warm Fantasy Umber (Default)
  }

  static Color getCardBackgroundForGenre(String? genre) {
    final g = (genre ?? '').toLowerCase();
    if (g.contains('sci-fi') || g.contains('cyber')) {
      return const Color(0xFFF0F9FF);
    } else if (g.contains('mystery') || g.contains('gothic')) {
      return const Color(0xFFF5F3FF);
    }
    return cardBg;
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryUmber,
        primary: primaryUmber,
        secondary: secondaryBronze,
        surface: cardBg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBg,
        foregroundColor: inkDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: inkDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: inkDark, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(color: inkDark, fontSize: 14, height: 1.5),
        titleMedium: TextStyle(color: inkDark, fontWeight: FontWeight.w600),
      ),
    );
  }
}
