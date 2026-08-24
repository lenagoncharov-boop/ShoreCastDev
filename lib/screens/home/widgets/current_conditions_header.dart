import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../models/location_model.dart';
import '../../../models/sea_condition_point.dart';

/// Big hero header: fishing rating score, location, and the two headline
/// numbers (wave height + wind), styled after Surfline's condition hero.
class CurrentConditionsHeader extends StatelessWidget {
  final CoastLocation location;
  final SeaConditionPoint current;
  final bool metricUnits;

  const CurrentConditionsHeader({
    super.key,
    required this.location,
    required this.current,
    required this.metricUnits,
  });

  @override
  Widget build(BuildContext context) {
    final rating = current.rating;
    final ratingColor = AppColors.ratingColor(rating.score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 16, color: AppColors.accentCyan),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location.displayName,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                UnitConverter.formatHeight(current.waveHeight, metric: metricUnits),
                style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, height: 1),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ratingColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ratingColor.withOpacity(0.6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.set_meal_rounded, size: 14, color: ratingColor),
                      const SizedBox(width: 4),
                      Text(
                        '${rating.label} · ${rating.score.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: ratingColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Wave height · ${current.swellPeriod.toStringAsFixed(0)}s period swell from the '
            '${_directionText(current.swellDirection)}',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  String _directionText(double deg) {
    const labels = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
    ];
    final idx = (((deg % 360) / 22.5) + 0.5).floor() % 16;
    return labels[idx];
  }
}
