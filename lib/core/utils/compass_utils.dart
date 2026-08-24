/// Compass direction helpers shared by wind/swell gauges and the hourly
/// table.
class CompassUtils {
  CompassUtils._();

  static const List<String> _labels = [
    'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
    'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
  ];

  /// Meteorological convention: degrees a wind/swell is coming FROM,
  /// 0 = North, 90 = East, etc. Matches Open-Meteo's *_direction fields.
  static String labelFor(double degrees) {
    final normalized = degrees % 360;
    final index = ((normalized / 22.5) + 0.5).floor() % 16;
    return _labels[index];
  }
}
