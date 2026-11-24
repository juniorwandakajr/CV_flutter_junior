import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Accents & dégradés qui restent identiques dans les 2 thèmes.
class AppColors {
  static const primary   = Color(0xFF6366F1);
  static const secondary = Color(0xFF8B5CF6);
  static const accent    = Color(0xFFF59E0B);
  static const teal      = Color(0xFF14B8A6);
  static const pink      = Color(0xFFEC4899);
  static const success   = Color(0xFF10B981);
  static const danger    = Color(0xFFEF4444);

  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const heroGradient = LinearGradient(
    colors: [primary, secondary, pink],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const warmGradient = LinearGradient(
    colors: [accent, danger],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const tealGradient = LinearGradient(
    colors: [teal, Color(0xFF06B6D4)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const cardGradients = <LinearGradient>[
    primaryGradient,
    warmGradient,
    tealGradient,
    LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)]),
    LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)]),
    LinearGradient(colors: [Color(0xFF10B981), Color(0xFF14B8A6)]),
  ];
}

class AppTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        bg: const Color(0xFFF8FAFC),
        surface: Colors.white,
        surfaceAlt: const Color(0xFFF1F5F9),
        onSurface: const Color(0xFF0F172A),
        onSurfaceVariant: const Color(0xFF64748B),
        outline: const Color(0xFFE2E8F0),
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        bg: const Color(0xFF0B1020),
        surface: const Color(0xFF1A2236),
        surfaceAlt: const Color(0xFF243049),
        onSurface: const Color(0xFFF1F5F9),
        onSurfaceVariant: const Color(0xFF94A3B8),
        outline: const Color(0xFF334155),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color surfaceAlt,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color outline,
  }) {
    final base = ThemeData(useMaterial3: true, brightness: brightness);
    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.teal,
      onTertiary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceAlt,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outline,
    );

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: scheme,
      textTheme: textTheme.apply(bodyColor: onSurface, displayColor: onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: Colors.white, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: onSurfaceVariant),
        hintStyle: TextStyle(color: onSurfaceVariant),
        border: _b(outline),
        enabledBorder: _b(outline),
        focusedBorder: _b(AppColors.primary, w: 1.6),
        errorBorder: _b(AppColors.danger),
        focusedErrorBorder: _b(AppColors.danger, w: 1.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF334155) : const Color(0xFF0F172A),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(color: outline, thickness: 1, space: 1),
      cardColor: surface,
      dialogTheme: DialogThemeData(backgroundColor: surface),
    );
  }

  static OutlineInputBorder _b(Color c, {double w = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );
}

/// Raccourci pratique dans tous les widgets.
extension AppCtx on BuildContext {
  ColorScheme get c => Theme.of(this).colorScheme;
  TextTheme  get t => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
