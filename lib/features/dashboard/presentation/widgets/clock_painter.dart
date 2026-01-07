import 'dart:math';
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime dateTime;
  final Color accentColor;

  ClockPainter({
    required this.dateTime,
    this.accentColor = const Color(
      0xFF16D0A7,
    ), // Default to a modern teal/green
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 4;

    // Outer Glow
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(center, radius + 4, glowPaint);

    // Glassy Background
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, backgroundPaint);

    // Border
    final outlineBrush = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, outlineBrush);

    // Hour Markers
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final isMainHour = i % 3 == 0;
      final markerLength = isMainHour ? 12 : 6;
      final markerWidth = isMainHour ? 3 : 1.5;

      final p1 = Offset(
        center.dx + (radius - 4) * cos(angle),
        center.dy + (radius - 4) * sin(angle),
      );
      final p2 = Offset(
        center.dx + (radius - 4 - markerLength) * cos(angle),
        center.dy + (radius - 4 - markerLength) * sin(angle),
      );

      final markerPaint = Paint()
        ..color = Colors.white.withValues(alpha: isMainHour ? 1.0 : 0.6)
        ..strokeWidth = markerWidth as double
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, markerPaint);
    }

    final secondHandLength = radius * 0.85;
    final minuteHandLength = radius * 0.7;
    final hourHandLength = radius * 0.5;

    final hour = dateTime.hour % 12;
    final minute = dateTime.minute;
    final second = dateTime.second;

    final hourHandAngle = (hour * 30 + minute * 0.5 - 90) * pi / 180;
    final minuteHandAngle = (minute * 6 - 90) * pi / 180;
    final secondHandAngle = (second * 6 - 90) * pi / 180;

    // Hour Hand
    _drawHandWithShadow(
      canvas,
      center,
      hourHandLength,
      hourHandAngle,
      5,
      Colors.white,
    );

    // Minute Hand
    _drawHandWithShadow(
      canvas,
      center,
      minuteHandLength,
      minuteHandAngle,
      3,
      Colors.white.withValues(alpha: 0.9),
    );

    // Second Hand
    final secondHandPaint = Paint()
      ..color = accentColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final secondHandGlow = Paint()
      ..color = accentColor.withValues(alpha: 0.6)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final secondHandEnd = Offset(
      center.dx + secondHandLength * cos(secondHandAngle),
      center.dy + secondHandLength * sin(secondHandAngle),
    );

    // Counter-balance for second hand
    final secondHandStart = Offset(
      center.dx - (secondHandLength * 0.2) * cos(secondHandAngle),
      center.dy - (secondHandLength * 0.2) * sin(secondHandAngle),
    );

    canvas.drawLine(secondHandStart, secondHandEnd, secondHandGlow);
    canvas.drawLine(secondHandStart, secondHandEnd, secondHandPaint);

    // Center Dot
    final centerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final centerDotBorder = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 5, centerDotPaint);
    canvas.drawCircle(center, 5, centerDotBorder);
  }

  void _drawHandWithShadow(
    Canvas canvas,
    Offset center,
    double length,
    double angle,
    double width,
    Color color,
  ) {
    final handEnd = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..strokeWidth = width + 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawLine(
      Offset(center.dx + 2, center.dy + 2),
      Offset(handEnd.dx + 2, handEnd.dy + 2),
      shadowPaint,
    );

    final handPaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, handEnd, handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
