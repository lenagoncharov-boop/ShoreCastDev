import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_forecast.dart';
import '../services/forecast_repository.dart';
import '../services/widget_service.dart';
import 'locations_provider.dart';
import 'settings_provider.dart';

/// Fetches merged marine+weather data for the active coast. Re-fetches
/// automatically whenever the active location changes, and pushes a
/// fresh snapshot to the Android home-screen widget on every successful
/// load. Periodic in-app auto-refresh (per the user's chosen interval in
/// Settings) is driven by a Timer set up in HomeScreen, which calls
/// `ref.invalidate(forecastProvider)`.
final forecastProvider = FutureProvider.autoDispose<List<DailyForecast>>((ref) async {
  final location = ref.watch(activeLocationProvider);
  final settings = ref.read(settingsProvider);

  final days = await ForecastRepository.fetch(lat: location.lat, lon: location.lon);

  if (days.isNotEmpty) {
    // Fire-and-forget: widget update should never block the UI.
    unawaited(WidgetService.pushUpdate(location: location, today: days.first, settings: settings));
  }

  return days;
});

/// Currently selected day index into the forecastProvider's list, used
/// by the day-detail screen and the 7-day strip's selection highlight.
final selectedDayIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
