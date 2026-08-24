import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// A small compass dial with an arrow pointing in the direction a
/// wind/swell is coming FROM. Used for wind and swell direction display,
/// echoing Surfline's directional dial widgets.
class CompassGauge extends StatelessWidget {
  final double directionDegrees;
  final Color color;
  final double size;
  final String? centerLabel;

  const CompassGauge({
    super.key,
    required this.directionDegrees,
    this.color = AppColors.accentCyan,
    this.size = 64,
    this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CompassPainter(directionDegrees: directionDegrees, color: color),
        child: centerLabel == null
            ? null
            : Center(
                child: Text(
                  centerLabel!,
                  style: TextStyle(
                    fontSize: size * 0.18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double directionDegrees;
  final Color color;

  _CompassPainter({required this.directionDegrees, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..color = AppColors.textFaint.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Tick marks every 30 degrees.
    for (var deg = 0; deg < 360; deg += 30) {
      final rad = deg * math.pi / 180;
      final outer = Offset(
        center.dx + (radius - 2) * math.sin(rad),
        center.dy - (radius - 2) * math.cos(rad),
      );
      final inner = Offset(
        center.dx + (radius - 7) * math.sin(rad),
        center.dy - (radius - 7) * math.cos(rad),
      );
      canvas.drawLine(inner, outer, ringPaint);
    }

    // Direction arrow: rotated so it points toward where the wind/swell
    // is coming FROM (meteorological convention), arrowhead outward.
    final rad = directionDegrees * math.pi / 180;
    final tip = Offset(
      center.dx + (radius - 10) * math.sin(rad),
      center.dy - (radius - 10) * math.cos(rad),
    );
    final tail = Offset(
      center.dx - (radius - 22) * math.sin(rad),
      center.dy + (radius - 22) * math.cos(rad),
    );

    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(tail, tip, arrowPaint);

    final headLength = radius * 0.22;
    final headAngle = 28 * math.pi / 180;
    final leftHead = Offset(
      tip.dx - headLength * math.sin(rad - headAngle),
      tip.dy + headLength * math.cos(rad - headAngle),
    );
    final rightHead = Offset(
      tip.dx - headLength * math.sin(rad + headAngle),
      tip.dy + headLength * math.cos(rad + headAngle),
    );
    final headPaint = Paint()..color = color;
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(leftHead.dx, leftHead.dy)
      ..lineTo(rightHead.dx, rightHead.dy)
      ..close();
    canvas.drawPath(path, headPaint);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) =>
      oldDelegate.directionDegrees != directionDegrees || oldDelegate.color != color;
}
