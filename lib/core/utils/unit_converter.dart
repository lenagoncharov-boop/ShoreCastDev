/// Conversion helpers. All API data arrives in metric (meters, km/h,
/// Celsius); we convert for display only when the user picks imperial
/// units in Settings.
class UnitConverter {
  UnitConverter._();

  static double metersToFeet(double meters) => meters * 3.28084;

  static double kmhToKnots(double kmh) => kmh * 0.539957;

  static double kmhToMph(double kmh) => kmh * 0.621371;

  static double celsiusToFahrenheit(double c) => c * 9 / 5 + 32;

  static String formatHeight(double meters, {required bool metric, int decimals = 1}) {
    if (metric) return '${meters.toStringAsFixed(decimals)} m';
    return '${metersToFeet(meters).toStringAsFixed(decimals)} ft';
  }

  static String formatWindSpeed(double kmh, {required bool metric, int decimals = 0}) {
    if (metric) return '${kmh.toStringAsFixed(decimals)} km/h';
    return '${kmhToKnots(kmh).toStringAsFixed(decimals)} kt';
  }

  static String formatTemp(double celsius, {required bool metric, int decimals = 0}) {
    if (metric) return '${celsius.toStringAsFixed(decimals)}°C';
    return '${celsiusToFahrenheit(celsius).toStringAsFixed(decimals)}°F';
  }

  static String formatPeriod(double seconds) => '${seconds.toStringAsFixed(0)}s';
}
