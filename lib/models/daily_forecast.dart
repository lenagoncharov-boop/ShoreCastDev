import '../core/utils/moon_phase.dart';
import 'sea_condition_point.dart';

class DailyForecast {
  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final double uvIndexMax;
  final List<SeaConditionPoint> hourly;

  const DailyForecast({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.uvIndexMax,
    required this.hourly,
  });

  MoonPhaseInfo get moonPhase => MoonPhaseCalculator.forDate(date);

  double get avgWaveHeight =>
      hourly.isEmpty ? 0 : hourly.map((h) => h.waveHeight).reduce((a, b) => a + b) / hourly.length;

  double get maxWaveHeight =>
      hourly.isEmpty ? 0 : hourly.map((h) => h.waveHeight).reduce((a, b) => a > b ? a : b);

  double get avgWindSpeed =>
      hourly.isEmpty ? 0 : hourly.map((h) => h.windSpeed).reduce((a, b) => a + b) / hourly.length;

  /// Best hour of the day by fishing rating — surfaced on the 7-day strip.
  SeaConditionPoint? get bestHour {
    if (hourly.isEmpty) return null;
    return hourly.reduce((a, b) => a.rating.score >= b.rating.score ? a : b);
  }

  double get dayRatingScore {
    if (hourly.isEmpty) return 0;
    return hourly.map((h) => h.rating.score).reduce((a, b) => a + b) / hourly.length;
  }

  /// Qualitative tide trend list across the day, derived from the slope
  /// of sea_level_height_msl between consecutive hours (see caveat in
  /// constants.dart). Not precise high/low timing.
  List<TideTrend> get hourlyTideTrend {
    final trends = <TideTrend>[];
    for (var i = 0; i < hourly.length; i++) {
      if (i == 0) {
        trends.add(TideTrend.slack);
        continue;
      }
      final delta = hourly[i].seaLevelMsl - hourly[i - 1].seaLevelMsl;
      if (delta > 0.01) {
        trends.add(TideTrend.rising);
      } else if (delta < -0.01) {
        trends.add(TideTrend.falling);
      } else {
        trends.add(TideTrend.slack);
      }
    }
    return trends;
  }
}
