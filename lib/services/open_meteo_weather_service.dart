import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class WeatherHourlyRaw {
  final List<DateTime> time;
  final List<double> airTemp;
  final List<double> windSpeed;
  final List<double> windDirection;
  final List<double> windGusts;
  final List<int> weatherCode;
  final List<double> cloudCover;
  final List<double> uvIndex;
  final List<double> precipitationProbability;

  const WeatherHourlyRaw({
    required this.time,
    required this.airTemp,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
    required this.weatherCode,
    required this.cloudCover,
    required this.uvIndex,
    required this.precipitationProbability,
  });
}

class WeatherDailyRaw {
  final List<DateTime> date;
  final List<DateTime> sunrise;
  final List<DateTime> sunset;
  final List<double> tempMax;
  final List<double> tempMin;
  final List<int> weatherCode;
  final List<double> uvIndexMax;

  const WeatherDailyRaw({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.uvIndexMax,
  });
}

class WeatherForecastResult {
  final WeatherHourlyRaw hourly;
  final WeatherDailyRaw daily;

  const WeatherForecastResult({required this.hourly, required this.daily});
}

class OpenMeteoWeatherService {
  static Future<WeatherForecastResult> fetchForecast({
    required double lat,
    required double lon,
    int forecastDays = ApiConstants.forecastDays,
  }) async {
    final uri = Uri.parse(ApiConstants.weatherBaseUrl).replace(queryParameters: {
      'latitude': lat.toStringAsFixed(4),
      'longitude': lon.toStringAsFixed(4),
      'hourly': ApiConstants.weatherHourlyParams.join(','),
      'daily': ApiConstants.weatherDailyParams.join(','),
      'forecast_days': forecastDays.toString(),
      'timezone': 'auto',
      'temperature_unit': 'celsius',
      'wind_speed_unit': 'kmh',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('Weather API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>?;
    final daily = json['daily'] as Map<String, dynamic>?;
    if (hourly == null || daily == null) {
      throw Exception('Weather API response missing hourly/daily block');
    }

    List<double> asDoubles(Map<String, dynamic> m, String key) =>
        ((m[key] as List?) ?? const []).map((e) => (e as num?)?.toDouble() ?? 0.0).toList();
    List<int> asInts(Map<String, dynamic> m, String key) =>
        ((m[key] as List?) ?? const []).map((e) => (e as num?)?.toInt() ?? 0).toList();

    final hourlyRaw = WeatherHourlyRaw(
      time: ((hourly['time'] as List?) ?? const []).map((e) => DateTime.parse(e as String)).toList(),
      airTemp: asDoubles(hourly, 'temperature_2m'),
      windSpeed: asDoubles(hourly, 'wind_speed_10m'),
      windDirection: asDoubles(hourly, 'wind_direction_10m'),
      windGusts: asDoubles(hourly, 'wind_gusts_10m'),
      weatherCode: asInts(hourly, 'weather_code'),
      cloudCover: asDoubles(hourly, 'cloud_cover'),
      uvIndex: asDoubles(hourly, 'uv_index'),
      precipitationProbability: asDoubles(hourly, 'precipitation_probability'),
    );

    final dailyRaw = WeatherDailyRaw(
      date: ((daily['time'] as List?) ?? const []).map((e) => DateTime.parse(e as String)).toList(),
      sunrise:
          ((daily['sunrise'] as List?) ?? const []).map((e) => DateTime.parse(e as String)).toList(),
      sunset: ((daily['sunset'] as List?) ?? const []).map((e) => DateTime.parse(e as String)).toList(),
      tempMax: asDoubles(daily, 'temperature_2m_max'),
      tempMin: asDoubles(daily, 'temperature_2m_min'),
      weatherCode: asInts(daily, 'weather_code'),
      uvIndexMax: asDoubles(daily, 'uv_index_max'),
    );

    return WeatherForecastResult(hourly: hourlyRaw, daily: dailyRaw);
  }
}
