import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/moon_phase.dart';

/// Draws a simple lit/shadowed moon disc for the given phase, rather than
/// relying on emoji glyph rendering (inconsistent across Android
/// devices/fonts).
class MoonPhaseIcon extends StatelessWidget {
  final MoonPhaseInfo phase;
  final double size;

  const MoonPhaseIcon({super.key, required this.phase, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MoonPainter(phase)),
    );
  }
}

class _MoonPainter extends CustomPainter {
  final MoonPhaseInfo phase;

  _MoonPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    final darkPaint = Paint()..color = AppColors.panelNavyLight;
    final litPaint = Paint()..color = const Color(0xFFF3EFD9);

    // Base disc: fully dark, then paint the lit crescent/gibbous on top.
    canvas.drawCircle(center, radius, darkPaint);

    final frac = phase.age / 29.530588853; // 0..1
    final waxing = frac < 0.5;
    // Terminator ellipse width follows cos curve; illumination fraction
    // maps to how much of the disc is lit.
    final illum = phase.illumination; // 0..1

    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));

    if (illum >= 0.999) {
      canvas.drawCircle(center, radius, litPaint);
    } else if (illum <= 0.001) {
      // fully dark, nothing to draw
    } else {
      // Draw lit half then subtract/add terminator ellipse to approximate
      // crescent/gibbous shapes.
      final litOnRight = waxing;
      final halfRect = Rect.fromLTWH(
        litOnRight ? center.dx : center.dx - radius,
        center.dy - radius,
        radius,
        radius * 2,
      );
      canvas.drawRect(halfRect, litPaint);

      final terminatorWidth = radius * (1 - 2 * (illum - 0.5).abs() * 2).abs();
      final isCrescent = illum < 0.5;
      final ellipsePaint = isCrescent ? darkPaint : litPaint;
      final ellipseRect = Rect.fromCenter(
        center: center,
        width: terminatorWidth.clamp(0, radius * 2),
        height: radius * 2,
      );
      canvas.drawOval(ellipseRect, ellipsePaint);
    }

    canvas.restore();

    final ringPaint = Paint()
      ..color = AppColors.textFaint.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _MoonPainter oldDelegate) => oldDelegate.phase.age != phase.age;
}
