import '../models/daily_forecast.dart';
import '../models/sea_condition_point.dart';
import 'open_meteo_marine_service.dart';
import 'open_meteo_weather_service.dart';

/// Fetches marine + weather data concurrently and merges them, hour by
/// hour and day by day, into a single list of [DailyForecast].
class ForecastRepository {
  static Future<List<DailyForecast>> fetch({required double lat, required double lon}) async {
    final results = await Future.wait([
      OpenMeteoMarineService.fetchHourly(lat: lat, lon: lon),
      OpenMeteoWeatherService.fetchForecast(lat: lat, lon: lon),
    ]);

    final marine = results[0] as MarineHourlyRaw;
    final weather = results[1] as WeatherForecastResult;

    // Merge hourly by matching timestamps (both APIs return the same
    // hourly grid when given the same forecast_days + timezone=auto).
    final weatherTimeIndex = <DateTime, int>{
      for (var i = 0; i < weather.hourly.time.length; i++) weather.hourly.time[i]: i,
    };

    final points = <SeaConditionPoint>[];
    for (var i = 0; i < marine.time.length; i++) {
      final t = marine.time[i];
      final wIdx = weatherTimeIndex[t];
      if (wIdx == null) continue;

      points.add(SeaConditionPoint(
        time: t,
        waveHeight: marine.waveHeight[i],
        waveDirection: marine.waveDirection[i],
        wavePeriod: marine.wavePeriod[i],
        windWaveHeight: marine.windWaveHeight[i],
        swellHeight: marine.swellHeight[i],
        swellDirection: marine.swellDirection[i],
        swellPeriod: marine.swellPeriod[i],
        seaSurfaceTemp: marine.seaSurfaceTemp[i],
        seaLevelMsl: marine.seaLevelMsl[i],
        airTemp: weather.hourly.airTemp[wIdx],
        windSpeed: weather.hourly.windSpeed[wIdx],
        windDirection: weather.hourly.windDirection[wIdx],
        windGusts: weather.hourly.windGusts[wIdx],
        weatherCode: weather.hourly.weatherCode[wIdx],
        cloudCover: weather.hourly.cloudCover[wIdx],
        uvIndex: weather.hourly.uvIndex[wIdx],
        precipitationProbability: weather.hourly.precipitationProbability[wIdx],
      ));
    }

    // Bucket hourly points by calendar day, then attach each day's
    // sunrise/sunset/min/max from the daily block.
    final days = <DailyForecast>[];
    for (var d = 0; d < weather.daily.date.length; d++) {
      final dayDate = weather.daily.date[d];
      final dayPoints = points
          .where((p) => p.time.year == dayDate.year && p.time.month == dayDate.month && p.time.day == dayDate.day)
          .toList()
        ..sort((a, b) => a.time.compareTo(b.time));

      if (dayPoints.isEmpty) continue;

      days.add(DailyForecast(
        date: dayDate,
        sunrise: weather.daily.sunrise[d],
        sunset: weather.daily.sunset[d],
        tempMax: weather.daily.tempMax[d],
        tempMin: weather.daily.tempMin[d],
        weatherCode: weather.daily.weatherCode[d],
        uvIndexMax: weather.daily.uvIndexMax[d],
        hourly: dayPoints,
      ));
    }

    return days;
  }
}
