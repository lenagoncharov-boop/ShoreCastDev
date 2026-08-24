// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get refreshNowTooltip => 'Refresh now';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get noForecastData => 'No forecast data returned.';

  @override
  String get hourlyBreakdown => 'Hourly breakdown';

  @override
  String get sevenDayOutlook => '7-day outlook';

  @override
  String get today => 'Today';

  @override
  String get swellLabel => 'Swell';

  @override
  String get windLabel => 'Wind';

  @override
  String windWavesSubvalue(String value) {
    return 'Wind waves $value';
  }

  @override
  String get airWaterTemp => 'Air / Water temp';

  @override
  String get uvIndexLabel => 'UV index';

  @override
  String cloudCoverSubvalue(String value) {
    return 'Cloud cover $value%';
  }

  @override
  String avgWaveMax(String avg, String max) {
    return 'Avg wave $avg · max $max';
  }

  @override
  String bestWindow(String time, String label, String score) {
    return 'Best window: $time · $label ($score)';
  }

  @override
  String get chooseCoast => 'Choose a coast';

  @override
  String get searchHint => 'Search a coastal town or beach…';

  @override
  String get useMyLocation => 'Use my current location';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationServicesOff => 'Location services are off.';

  @override
  String get myLocationName => 'My location';

  @override
  String couldntGetLocation(String error) {
    return 'Couldn\'t get location: $error';
  }

  @override
  String searchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String get searchResults => 'Search results';

  @override
  String get savedCoasts => 'Saved coasts';

  @override
  String get suggestedCoasts => 'Suggested coasts';

  @override
  String get couldntLoadConditions => 'Couldn\'t load sea conditions';

  @override
  String get retry => 'Retry';

  @override
  String get fetchingConditions => 'Fetching sea conditions…';

  @override
  String waveHeightCaption(String period, String direction) {
    return 'Wave height · ${period}s period swell from the $direction';
  }

  @override
  String get waveHeightChartTitle => 'Wave height';

  @override
  String get windSpeedChartTitle => 'Wind speed';

  @override
  String get waveShort => 'wave';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String litPercent(String percent) {
    return '$percent% lit';
  }

  @override
  String tideWithTrend(String trend) {
    return 'Tide · $trend';
  }

  @override
  String get tideCaption =>
      'Approx. trend from sea-level model, not a tide-table prediction';

  @override
  String get unitsSection => 'Units';

  @override
  String get metricUnits => 'Metric units';

  @override
  String get unitsMetricSubtitle => 'Meters, km/h, °C';

  @override
  String get unitsImperialSubtitle => 'Feet, knots, °F';

  @override
  String get refreshSection => 'Refresh';

  @override
  String get autoRefreshInterval => 'Auto-refresh interval';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String get widgetAutoRefresh => 'Auto-refresh home-screen widget';

  @override
  String get widgetAutoRefreshSubtitle =>
      'Uses the interval above. You can always tap the widget\'s refresh icon manually.';

  @override
  String get aboutDataSection => 'About the data';

  @override
  String get aboutDataIntro =>
      'ShoreCast uses free, open weather and marine data:';

  @override
  String get aboutDataSources =>
      '• Open-Meteo Marine Weather API — wave height, swell, wind waves, sea temperature\n• Open-Meteo Weather API — air temperature, wind, sunrise/sunset, UV, cloud cover\n• Open-Meteo Geocoding API — coastal location search\n• Moon phase is computed locally from an astronomical formula (no API call)';

  @override
  String get tideNoteTitle => 'Tide note';

  @override
  String get tideNoteBody =>
      'There is currently no free, key-less, worldwide source of real harmonic tide predictions. The tide trend shown (rising/falling) is derived from Open-Meteo\'s blended sea-level signal, which is a good qualitative guide but not a precise tide-table time or height — treat it as an estimate.';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageSystemSubtitle => 'Follows your phone\'s language';
}
