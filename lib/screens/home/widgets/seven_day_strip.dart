import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../core/utils/weather_code.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/daily_forecast.dart';

class SevenDayStrip extends StatelessWidget {
  final List<DailyForecast> days;
  final bool metricUnits;
  final void Function(int index) onSelectDay;

  const SevenDayStrip({
    super.key,
    required this.days,
    required this.metricUnits,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = days[index];
          final weatherInfo = WeatherCodeInfo.forCode(day.weatherCode);
          final ratingColor = AppColors.ratingColor(day.dayRatingScore);
          final isToday = index == 0;

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onSelectDay(index),
            child: Container(
              width: 104,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isToday ? AppColors.accentCyan : AppColors.divider),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isToday ? l10n.today : DateFormat('EEE').format(day.date),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    DateFormat('d MMM').format(day.date),
                    style: const TextStyle(fontSize: 10, color: AppColors.textFaint),
                  ),
                  Icon(weatherInfo.icon, color: AppColors.accentAmber, size: 22),
                  Text(
                    UnitConverter.formatHeight(day.avgWaveHeight, metric: metricUnits, decimals: 1),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    width: 28,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ratingColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
