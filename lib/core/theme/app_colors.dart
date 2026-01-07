import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.surface,
    required this.surfaceElevated,
    required this.scaffold,
    required this.border,
    required this.borderSubtle,
    required this.primaryGradient,
    required this.cardGradient,
    required this.accentGradient,
    required this.shadow,
    required this.glass,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.success,
    required this.warning,
    required this.accent,
    // Ultra-modern additions
    required this.neonGradient,
    required this.meshGradient,
    required this.holographicGradient,
    required this.glowPrimary,
    required this.glowSecondary,
    required this.glowAccent,
    required this.deepShadow,
    required this.floatingShadow,
  });

  final Color surface;
  final Color surfaceElevated;
  final Color scaffold;
  final Color border;
  final Color borderSubtle;
  final Gradient primaryGradient;
  final Gradient cardGradient;
  final Gradient accentGradient;
  final Color shadow;
  final Color glass;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color success;
  final Color warning;
  final Color accent;

  // Ultra-modern visual properties
  final Gradient neonGradient;
  final Gradient meshGradient;
  final Gradient holographicGradient;
  final Color glowPrimary;
  final Color glowSecondary;
  final Color glowAccent;
  final Color deepShadow;
  final Color floatingShadow;

  @override
  AppColors copyWith({
    Color? surface,
    Color? surfaceElevated,
    Color? scaffold,
    Color? border,
    Color? borderSubtle,
    Gradient? primaryGradient,
    Gradient? cardGradient,
    Gradient? accentGradient,
    Color? shadow,
    Color? glass,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? success,
    Color? warning,
    Color? accent,
    Gradient? neonGradient,
    Gradient? meshGradient,
    Gradient? holographicGradient,
    Color? glowPrimary,
    Color? glowSecondary,
    Color? glowAccent,
    Color? deepShadow,
    Color? floatingShadow,
  }) {
    return AppColors(
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      scaffold: scaffold ?? this.scaffold,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      accentGradient: accentGradient ?? this.accentGradient,
      shadow: shadow ?? this.shadow,
      glass: glass ?? this.glass,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      accent: accent ?? this.accent,
      neonGradient: neonGradient ?? this.neonGradient,
      meshGradient: meshGradient ?? this.meshGradient,
      holographicGradient: holographicGradient ?? this.holographicGradient,
      glowPrimary: glowPrimary ?? this.glowPrimary,
      glowSecondary: glowSecondary ?? this.glowSecondary,
      glowAccent: glowAccent ?? this.glowAccent,
      deepShadow: deepShadow ?? this.deepShadow,
      floatingShadow: floatingShadow ?? this.floatingShadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      primaryGradient: Gradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      cardGradient: Gradient.lerp(cardGradient, other.cardGradient, t)!,
      accentGradient: Gradient.lerp(accentGradient, other.accentGradient, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      neonGradient: Gradient.lerp(neonGradient, other.neonGradient, t)!,
      meshGradient: Gradient.lerp(meshGradient, other.meshGradient, t)!,
      holographicGradient: Gradient.lerp(
        holographicGradient,
        other.holographicGradient,
        t,
      )!,
      glowPrimary: Color.lerp(glowPrimary, other.glowPrimary, t)!,
      glowSecondary: Color.lerp(glowSecondary, other.glowSecondary, t)!,
      glowAccent: Color.lerp(glowAccent, other.glowAccent, t)!,
      deepShadow: Color.lerp(deepShadow, other.deepShadow, t)!,
      floatingShadow: Color.lerp(floatingShadow, other.floatingShadow, t)!,
    );
  }
}
