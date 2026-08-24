/// App-wide constants: API endpoints, storage keys, default values.
///
/// Data sources (both free, no API key required):
///   - Open-Meteo Marine Weather API  -> waves, swell, sea surface temp, sea level trend
///   - Open-Meteo Weather Forecast API -> air temp, wind, sunrise/sunset, cloud cover, UV
///   - Open-Meteo Geocoding API        -> location search for the coast picker
///
/// IMPORTANT CAVEAT (documented in-app, see SettingsScreen "About data"):
/// Open-Meteo's `sea_level_height_msl` is a blended total-sea-level signal
/// (astronomical tide + inverse barometer + steric effects), NOT a harmonic
/// tide-table prediction. We use it only to derive a qualitative
/// rising/falling trend and an approximate high/low turning point — never
/// as a precise tide height/time. There is currently no free, key-less,
/// global source of real harmonic tide predictions.
class ApiConstants {
  ApiConstants._();

  static const String marineBaseUrl = 'https://marine-api.open-meteo.com/v1/marine';
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  static const List<String> marineHourlyParams = [
    'wave_height',
    'wave_direction',
    'wave_period',
    'wind_wave_height',
    'wind_wave_direction',
    'wind_wave_period',
    'swell_wave_height',
    'swell_wave_direction',
    'swell_wave_period',
    'sea_surface_temperature',
    'sea_level_height_msl',
  ];

  static const List<String> weatherHourlyParams = [
    'temperature_2m',
    'wind_speed_10m',
    'wind_direction_10m',
    'wind_gusts_10m',
    'weather_code',
    'cloud_cover',
    'uv_index',
    'precipitation_probability',
  ];

  static const List<String> weatherDailyParams = [
    'sunrise',
    'sunset',
    'temperature_2m_max',
    'temperature_2m_min',
    'weather_code',
    'uv_index_max',
  ];

  static const int forecastDays = 7;
}

class StorageKeys {
  StorageKeys._();

  static const String settings = 'shorecast_settings_v1';
  static const String savedLocations = 'shorecast_saved_locations_v1';
  static const String activeLocationId = 'shorecast_active_location_v1';
  static const String cachedForecastPrefix = 'shorecast_cache_';
}

class WidgetConstants {
  WidgetConstants._();

  static const String androidWidgetName = 'SeaConditionWidgetProvider';
  static const String appGroupId = 'group.com.shorecast.widget';

  // Keys written into the shared widget data store (read by the native
  // Kotlin AppWidgetProvider). Keep in sync with widget_service.dart and
  // the Kotlin provider in android_widget_integration/.
  static const String keyLocationName = 'widget_location_name';
  static const String keyWaveHeight = 'widget_wave_height';
  static const String keyWavePeriod = 'widget_wave_period';
  static const String keySwellDirection = 'widget_swell_direction';
  static const String keyWindSpeed = 'widget_wind_speed';
  static const String keyWindDirection = 'widget_wind_direction';
  static const String keyAirTemp = 'widget_air_temp';
  static const String keyWaterTemp = 'widget_water_temp';
  static const String keyTideTrend = 'widget_tide_trend';
  static const String keyRatingLabel = 'widget_rating_label';
  static const String keyRatingScore = 'widget_rating_score';
  static const String keyUpdatedAt = 'widget_updated_at';
  static const String keyUnits = 'widget_units_is_metric';
}

/// Default coast shown on first launch. Israel / Eastern Mediterranean
/// (Herzliya) was chosen to match the app's configured timezone; change
/// any time via the location picker.
class DefaultLocation {
  DefaultLocation._();

  static const String name = 'Herzliya, Israel';
  static const double lat = 32.1624;
  static const double lon = 34.7936;
}

const List<int> refreshIntervalOptionsMinutes = [15, 30, 60, 120, 180];
