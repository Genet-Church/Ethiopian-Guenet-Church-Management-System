import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:genet_church_portal/core/theme/app_colors.dart';

class AppTheme {
  // Modern Light Theme Colors - Enhanced for 2025
  static const Color _lightPrimaryBlue = Color(0xFF2563EB);
  static const Color _lightAccentTeal = Color(0xFF06B6D4);
  static const Color _lightAccentPurple = Color(0xFF8B5CF6);
  static const Color _lightDestructiveRed = Color(0xFFEF4444);
  static const Color _lightSuccessGreen = Color(0xFF10B981);
  static const Color _lightWarningOrange = Color(0xFFF59E0B);
  static const Color _lightSurfaceWhite = Color(0xFFFFFFFF);
  static const Color _lightSurfaceElevated = Color(0xFFFBFBFB);
  static const Color _lightScaffoldBackground = Color(0xFFF8FAFC);
  static const Color _lightBorder = Color(0xFFE2E8F0);
  static const Color _lightBorderSubtle = Color(0xFFF1F5F9);
  static const Color _lightTextPrimary = Color(0xFF0F172A);
  static const Color _lightTextSecondary = Color(0xFF64748B);
  static const Color _lightTextTertiary = Color(0xFF94A3B8);

  // Ultra-modern additions for Light Theme
  static const Color _lightNeonBlue = Color(0xFF00D4FF);
  static const Color _lightNeonPurple = Color(0xFFBF40BF);
  static const Color _lightNeonPink = Color(0xFFFF10F0);
  static const Color _lightHoloPurple = Color(0xFF9D4EDD);
  static const Color _lightHoloBlue = Color(0xFF3C096C);
  static const Color _lightHoloPink = Color(0xFFE0AAFF);
  static const Color _lightGlowBlue = Color(0xFF0EA5E9);
  static const Color _lightGlowPurple = Color(0xFFA855F7);
  static const Color _lightGlowTeal = Color(0xFF14B8A6);

  // Modern Dark Theme Colors - Enhanced for 2025
  static const Color _darkPrimaryBlue = Color(0xFF3B82F6);
  static const Color _darkAccentTeal = Color(0xFF22D3EE);
  static const Color _darkAccentPurple = Color(0xFFA855F7);
  static const Color _darkDestructiveRed = Color(0xFFF87171);
  static const Color _darkSuccessGreen = Color(0xFF34D399);
  static const Color _darkWarningOrange = Color(0xFFFBBF24);
  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkSurfaceElevated = Color(0xFF1E1E1E);
  static const Color _darkScaffold = Color(0xFF000000);
  static const Color _darkBorder = Color(0xFF475569);
  static const Color _darkBorderSubtle = Color(0xFF334155);
  static const Color _darkTextPrimary = Color(0xFFF8FAFC);
  static const Color _darkTextSecondary = Color(0xFFCBD5E1);
  static const Color _darkTextTertiary = Color(0xFF94A3B8);

  // Ultra-modern additions for Dark Theme
  static const Color _darkNeonBlue = Color(0xFF00F0FF);
  static const Color _darkNeonPurple = Color(0xFFDA70D6);
  static const Color _darkNeonPink = Color(0xFFFF1493);
  static const Color _darkHoloPurple = Color(0xFFB47AEA);
  static const Color _darkHoloBlue = Color(0xFF7B2CBF);
  static const Color _darkHoloPink = Color(0xFFFEC6FF);
  static const Color _darkGlowBlue = Color(0xFF38BDF8);
  static const Color _darkGlowPurple = Color(0xFFC084FC);
  static const Color _darkGlowTeal = Color(0xFF2DD4BF);

  static const _appColorsLight = AppColors(
    surface: _lightSurfaceWhite,
    surfaceElevated: _lightSurfaceElevated,
    scaffold: _lightScaffoldBackground,
    border: _lightBorder,
    borderSubtle: _lightBorderSubtle,
    primaryGradient: LinearGradient(
      colors: [_lightPrimaryBlue, _lightAccentTeal],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardGradient: LinearGradient(
      colors: [_lightSurfaceWhite, _lightSurfaceElevated],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [_lightAccentTeal, _lightAccentPurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    shadow: Color(0x0F000000),
    glass: Color(0x80FFFFFF),
    shimmerBase: Color(0xFFE2E8F0),
    shimmerHighlight: Color(0xFFF8FAFC),
    textPrimary: _lightTextPrimary,
    textSecondary: _lightTextSecondary,
    textTertiary: _lightTextTertiary,
    success: _lightSuccessGreen,
    warning: _lightWarningOrange,
    accent: _lightAccentPurple,
    // Ultra-modern additions
    neonGradient: LinearGradient(
      colors: [_lightNeonBlue, _lightNeonPurple, _lightNeonPink],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
    ),
    meshGradient: LinearGradient(
      colors: [
        _lightPrimaryBlue,
        _lightAccentTeal,
        _lightAccentPurple,
        _lightNeonPink,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.33, 0.66, 1.0],
    ),
    holographicGradient: LinearGradient(
      colors: [_lightHoloBlue, _lightHoloPurple, _lightHoloPink],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
    ),
    glowPrimary: _lightGlowBlue,
    glowSecondary: _lightGlowTeal,
    glowAccent: _lightGlowPurple,
    deepShadow: Color(0x20000000),
    floatingShadow: Color(0x15000000),
  );

  static const _appColorsDark = AppColors(
    surface: _darkSurface,
    surfaceElevated: _darkSurfaceElevated,
    scaffold: _darkScaffold,
    border: _darkBorder,
    borderSubtle: _darkBorderSubtle,
    primaryGradient: LinearGradient(
      colors: [_darkPrimaryBlue, _darkAccentTeal],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardGradient: LinearGradient(
      colors: [_darkSurface, _darkSurfaceElevated],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [_darkAccentTeal, _darkAccentPurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    shadow: Color(0x40000000),
    glass: Color(0x1AFFFFFF),
    shimmerBase: Color(0xFF334155),
    shimmerHighlight: Color(0xFF475569),
    textPrimary: _darkTextPrimary,
    textSecondary: _darkTextSecondary,
    textTertiary: _darkTextTertiary,
    success: _darkSuccessGreen,
    warning: _darkWarningOrange,
    accent: _darkAccentPurple,
    // Ultra-modern additions
    neonGradient: LinearGradient(
      colors: [_darkNeonBlue, _darkNeonPurple, _darkNeonPink],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
    ),
    meshGradient: LinearGradient(
      colors: [
        _darkPrimaryBlue,
        _darkAccentTeal,
        _darkAccentPurple,
        _darkNeonPink,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.33, 0.66, 1.0],
    ),
    holographicGradient: LinearGradient(
      colors: [_darkHoloBlue, _darkHoloPurple, _darkHoloPink],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 0.5, 1.0],
    ),
    glowPrimary: _darkGlowBlue,
    glowSecondary: _darkGlowTeal,
    glowAccent: _darkGlowPurple,
    deepShadow: Color(0x50000000),
    floatingShadow: Color(0x30000000),
  );

  static final ThemeData lightTheme = ThemeData(
    primaryColor: _lightPrimaryBlue,
    scaffoldBackgroundColor: _lightScaffoldBackground,
    brightness: Brightness.light,
    useMaterial3: true,
    extensions: const <ThemeExtension<dynamic>>[_appColorsLight],
    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryBlue,
      secondary: _lightAccentTeal,
      error: _lightDestructiveRed,
      surface: _lightSurfaceWhite,
      onSurface: _lightTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: -0.8,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: -0.2,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        color: _lightTextSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        color: _lightTextSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.2,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        color: _lightTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.3,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        color: _lightTextSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.3,
        height: 1.3,
      ),
      labelSmall: GoogleFonts.inter(
        color: _lightTextSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.4,
        height: 1.3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurfaceWhite,
      hintStyle: const TextStyle(color: _lightTextSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightPrimaryBlue, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _lightPrimaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: _darkPrimaryBlue,
    scaffoldBackgroundColor: _darkScaffold,
    brightness: Brightness.dark,
    useMaterial3: true,
    extensions: const <ThemeExtension<dynamic>>[_appColorsDark],
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryBlue,
      secondary: _darkAccentTeal,
      error: _darkDestructiveRed,
      surface: _darkSurface,
      onSurface: _darkTextPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 32,
        letterSpacing: -0.8,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: -0.2,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        color: _darkTextSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        color: _darkTextSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.2,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        color: _darkTextPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.3,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        color: _darkTextSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0.3,
        height: 1.3,
      ),
      labelSmall: GoogleFonts.inter(
        color: _darkTextSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.4,
        height: 1.3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkScaffold,
      hintStyle: const TextStyle(color: _darkTextSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkPrimaryBlue, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _darkPrimaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
