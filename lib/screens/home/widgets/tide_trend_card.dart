import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/native_labels.dart';
import '../../../models/daily_forecast.dart';
import '../../../models/sea_condition_point.dart';

/// Qualitative rising/falling tide indicator for the current hour, plus a
/// tiny sparkline of the day's sea-level trend. See the caveat in
/// constants.dart: this is derived from Open-Meteo's blended sea-level
/// signal, not a harmonic tide-table prediction.
class TideTrendCard extends StatelessWidget {
  final DailyForecast day;
  final int currentHourIndex;

  const TideTrendCard({super.key, required this.day, required this.currentHourIndex});

  @override
  Widget build(BuildContext context) {
    final trends = day.hourlyTideTrend;
    final trend = currentHourIndex < trends.length ? trends[currentHourIndex] : TideTrend.slack;
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;

    final IconData icon;
    final Color color;
    switch (trend) {
      case TideTrend.rising:
        icon = Icons.trending_up_rounded;
        color = AppColors.goodGreen;
        break;
      case TideTrend.falling:
        icon = Icons.trending_down_rounded;
        color = AppColors.accentAmber;
        break;
      case TideTrend.slack:
        icon = Icons.trending_flat_rounded;
        color = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.16), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tideWithTrend(tideTrendLabel(lang, trend)),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  l10n.tideCaption,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            height: 32,
            child: CustomPaint(painter: _SparklinePainter(day.hourly, color)),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<SeaConditionPoint> hourly;
  final Color color;

  _SparklinePainter(this.hourly, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (hourly.length < 2) return;
    final values = hourly.map((h) => h.seaLevelMsl).toList();
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - ((values[i] - minV) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => true;
}
