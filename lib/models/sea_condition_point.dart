import '../core/utils/wave_rating.dart';

/// A single hour of combined marine + weather data.
class SeaConditionPoint {
  final DateTime time;

  // Marine
  final double waveHeight; // m
  final double waveDirection; // deg, from
  final double wavePeriod; // s
  final double windWaveHeight; // m
  final double swellHeight; // m
  final double swellDirection; // deg, from
  final double swellPeriod; // s
  final double seaSurfaceTemp; // C
  final double seaLevelMsl; // m, blended signal (not pure astronomical tide)

  // Weather
  final double airTemp; // C
  final double windSpeed; // km/h
  final double windDirection; // deg, from
  final double windGusts; // km/h
  final int weatherCode;
  final double cloudCover; // %
  final double uvIndex;
  final double precipitationProbability; // %

  const SeaConditionPoint({
    required this.time,
    required this.waveHeight,
    required this.waveDirection,
    required this.wavePeriod,
    required this.windWaveHeight,
    required this.swellHeight,
    required this.swellDirection,
    required this.swellPeriod,
    required this.seaSurfaceTemp,
    required this.seaLevelMsl,
    required this.airTemp,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
    required this.weatherCode,
    required this.cloudCover,
    required this.uvIndex,
    required this.precipitationProbability,
  });

  FishingRating get rating => FishingRating.compute(
        waveHeightM: waveHeight,
        windSpeedKmh: windSpeed,
        swellPeriodS: swellPeriod,
      );
}

enum TideTrend { rising, falling, slack }

extension TideTrendX on TideTrend {
  String get label {
    switch (this) {
      case TideTrend.rising:
        return 'Rising';
      case TideTrend.falling:
        return 'Falling';
      case TideTrend.slack:
        return 'Slack';
    }
  }
}
