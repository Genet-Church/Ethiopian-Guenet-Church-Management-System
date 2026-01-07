import 'dart:ui';
import 'package:flutter/material.dart';

/// Visual Effects Utility
/// Provides reusable visual effect utilities for ultra-modern  UI components
class VisualEffects {
  VisualEffects._();

  /// Creates a glow effect with customizable color and intensity
  static List<BoxShadow> createGlow({
    required Color color,
    double intensity = 0.6,
    double blur = 24.0,
    double spread = 0.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: blur,
        spreadRadius: spread,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.5),
        blurRadius: blur * 1.5,
        spreadRadius: spread * 0.5,
        offset: Offset.zero,
      ),
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.25),
        blurRadius: blur * 2,
        spreadRadius: spread * 0.25,
        offset: Offset.zero,
      ),
    ];
  }

  /// Creates a neon glow border effect
  static BoxDecoration createNeonBorder({
    required Color color,
    double borderRadius = 16.0,
    double borderWidth = 2.0,
    double glowIntensity = 0.8,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: color, width: borderWidth),
      boxShadow: createGlow(color: color, intensity: glowIntensity, blur: 20.0),
    );
  }

  /// Creates a glassmorphism effect with backdrop blur
  static BoxDecoration createGlassmorphism({
    required Color backgroundColor,
    required Color borderColor,
    double borderRadius = 20.0,
    double borderWidth = 1.0,
    List<BoxShadow>? customShadows,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow:
          customShadows ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
    );
  }

  /// Creates a floating effect with layered shadows
  static List<BoxShadow> createFloatingShadow({
    required Color shadowColor,
    double elevation = 12.0,
  }) {
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.15),
        blurRadius: elevation * 4,
        offset: Offset(0, elevation),
        spreadRadius: -elevation * 0.5,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.12),
        blurRadius: elevation * 2.5,
        offset: Offset(0, elevation * 0.6),
        spreadRadius: -elevation * 0.3,
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.08),
        blurRadius: elevation * 1.5,
        offset: Offset(0, elevation * 0.3),
        spreadRadius: -elevation * 0.2,
      ),
    ];
  }

  /// Creates a 3D depth effect with multiple shadow layers
  static List<BoxShadow> create3DDepth({
    required Color lightShadow,
    required Color darkShadow,
    double depth = 8.0,
  }) {
    return [
      BoxShadow(
        color: lightShadow.withValues(alpha: 0.2),
        blurRadius: depth * 0.5,
        offset: Offset(-depth * 0.25, -depth * 0.25),
      ),
      BoxShadow(
        color: darkShadow.withValues(alpha: 0.25),
        blurRadius: depth,
        offset: Offset(depth * 0.5, depth * 0.5),
      ),
      BoxShadow(
        color: darkShadow.withValues(alpha: 0.15),
        blurRadius: depth * 1.5,
        offset: Offset(depth * 0.75, depth * 0.75),
      ),
    ];
  }

  /// Creates a shimmer gradient for loading states
  static LinearGradient createShimmer({
    required Color baseColor,
    required Color highlightColor,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [baseColor, highlightColor, baseColor],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// Creates a holographic gradient effect
  static LinearGradient createHolographic({
    required List<Color> colors,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: stops ?? [0.0, 0.5, 1.0],
      transform: const GradientRotation(0.1),
    );
  }

  /// Creates a mesh gradient (multi-stop gradient)
  static LinearGradient createMeshGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    final stops = List<double>.generate(
      colors.length,
      (index) => index / (colors.length - 1),
    );
    return LinearGradient(begin: begin, end: end, colors: colors, stops: stops);
  }

  /// Applies a backdrop blur filter
  static ImageFilter createBackdropBlur({
    double sigmaX = 10.0,
    double sigmaY = 10.0,
  }) {
    return ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY);
  }
}

/// Predefined Animation Curves for consistent animations
class ModernCurves {
  ModernCurves._();

  /// Smooth ease-out curve for natural motion
  static const Curve smoothOut = Curves.easeOutCubic;

  /// Smooth ease-in curve
  static const Curve smoothIn = Curves.easeInCubic;

  /// Bouncy effect for playful interactions
  static const Curve bounce = Curves.easeOutBack;

  /// Elastic effect for attention-grabbing animations
  static const Curve elastic = Curves.elasticOut;

  /// Emphasized curve for important transitions
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Standard curve for most transitions
  static const Curve standard = Curves.easeInOut;
}

/// Predefined Animation Durations for consistency
class ModernDurations {
  ModernDurations._();

  /// Very fast animations (100ms)
  static const Duration veryFast = Duration(milliseconds: 100);

  /// Fast animations (200ms)
  static const Duration fast = Duration(milliseconds: 200);

  /// Standard animations (300ms)
  static const Duration standard = Duration(milliseconds: 300);

  /// Medium animations (400ms)
  static const Duration medium = Duration(milliseconds: 400);

  /// Slow animations (600ms)
  static const Duration slow = Duration(milliseconds: 600);

  /// Very slow animations (800ms)
  static const Duration verySlow = Duration(milliseconds: 800);
}
