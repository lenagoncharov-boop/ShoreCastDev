import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

/// Raw hourly marine data, indexed by hour, straight off the wire.
class MarineHourlyRaw {
  final List<DateTime> time;
  final List<double> waveHeight;
  final List<double> waveDirection;
  final List<double> wavePeriod;
  final List<double> windWaveHeight;
  final List<double> swellHeight;
  final List<double> swellDirection;
  final List<double> swellPeriod;
  final List<double> seaSurfaceTemp;
  final List<double> seaLevelMsl;

  const MarineHourlyRaw({
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
  });
}

class OpenMeteoMarineService {
  static Future<MarineHourlyRaw> fetchHourly({
    required double lat,
    required double lon,
    int forecastDays = ApiConstants.forecastDays,
  }) async {
    final uri = Uri.parse(ApiConstants.marineBaseUrl).replace(queryParameters: {
      'latitude': lat.toStringAsFixed(4),
      'longitude': lon.toStringAsFixed(4),
      'hourly': ApiConstants.marineHourlyParams.join(','),
      'forecast_days': forecastDays.toString(),
      'timezone': 'auto',
      'length_unit': 'metric',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('Marine API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>?;
    if (hourly == null) {
      throw Exception('Marine API response missing hourly block');
    }

    List<double> asDoubles(String key) => ((hourly[key] as List?) ?? const [])
        .map((e) => (e as num?)?.toDouble() ?? 0.0)
        .toList();

    final times = ((hourly['time'] as List?) ?? const [])
        .map((e) => DateTime.parse(e as String))
        .toList();

    return MarineHourlyRaw(
      time: times,
      waveHeight: asDoubles('wave_height'),
      waveDirection: asDoubles('wave_direction'),
      wavePeriod: asDoubles('wave_period'),
      windWaveHeight: asDoubles('wind_wave_height'),
      swellHeight: asDoubles('swell_wave_height'),
      swellDirection: asDoubles('swell_wave_direction'),
      swellPeriod: asDoubles('swell_wave_period'),
      seaSurfaceTemp: asDoubles('sea_surface_temperature'),
      seaLevelMsl: asDoubles('sea_level_height_msl'),
    );
  }
}
