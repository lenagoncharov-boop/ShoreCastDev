import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../core/utils/weather_code.dart';
import '../../../models/daily_forecast.dart';
import '../../../models/sea_condition_point.dart';
import '../../../widgets/compass_gauge.dart';

/// Horizontally scrollable per-hour breakdown, the "hourly table" required
/// alongside the graphs — every key parameter in one glanceable row.
class HourlyTable extends StatelessWidget {
  final DailyForecast day;
  final bool metricUnits;

  const HourlyTable({super.key, required this.day, required this.metricUnits});

  @override
  Widget build(BuildContext context) {
    final trends = day.hourlyTideTrend;
    final timeFmt = DateFormat('HH:mm');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < day.hourly.length; i++)
            _HourColumn(
              point: day.hourly[i],
              trend: i < trends.length ? trends[i] : TideTrend.slack,
              timeLabel: timeFmt.format(day.hourly[i].time),
              metricUnits: metricUnits,
            ),
        ],
      ),
    );
  }
}

class _HourColumn extends StatelessWidget {
  final SeaConditionPoint point;
  final TideTrend trend;
  final String timeLabel;
  final bool metricUnits;

  const _HourColumn({
    required this.point,
    required this.trend,
    required this.timeLabel,
    required this.metricUnits,
  });

  @override
  Widget build(BuildContext context) {
    final weatherInfo = WeatherCodeInfo.forCode(point.weatherCode);
    final ratingColor = AppColors.ratingColor(point.rating.score);

    final IconData tideIcon;
    switch (trend) {
      case TideTrend.rising:
        tideIcon = Icons.arrow_upward_rounded;
        break;
      case TideTrend.falling:
        tideIcon = Icons.arrow_downward_rounded;
        break;
      case TideTrend.slack:
        tideIcon = Icons.remove_rounded;
        break;
    }

    return Container(
      width: 76,
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ratingColor, width: 3)),
      ),
      child: Column(
        children: [
          Text(timeLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Icon(weatherInfo.icon, size: 18, color: AppColors.accentAmber),
          const SizedBox(height: 6),
          Text(
            UnitConverter.formatHeight(point.waveHeight, metric: metricUnits),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          Text('wave', style: const TextStyle(fontSize: 9, color: AppColors.textFaint)),
          const SizedBox(height: 8),
          CompassGauge(directionDegrees: point.windDirection, size: 28, color: AppColors.accentBlue),
          const SizedBox(height: 4),
          Text(
            UnitConverter.formatWindSpeed(point.windSpeed, metric: metricUnits),
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            UnitConverter.formatTemp(point.airTemp, metric: metricUnits),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Icon(tideIcon, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
