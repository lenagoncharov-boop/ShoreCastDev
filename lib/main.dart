import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';
import 'models/location_model.dart';
import 'services/background_refresh_service.dart';
import 'services/forecast_repository.dart';
import 'services/location_storage_service.dart';
import 'services/settings_service.dart';
import 'services/widget_service.dart';

/// Fetches fresh data and pushes it to the native widget. Shared by both
/// background entry points below (WorkManager's periodic tick, and the
/// widget's manual refresh tap) so they behave identically.
Future<void> _refreshWidgetData() async {
  try {
    final settings = await SettingsService.load();
    final saved = await LocationStorageService.loadSaved();
    final activeId = await LocationStorageService.loadActiveLocationId();
    final CoastLocation active = saved.firstWhere(
      (l) => l.id == activeId,
      orElse: () => saved.first,
    );
    final days = await ForecastRepository.fetch(lat: active.lat, lon: active.lon);
    if (days.isNotEmpty) {
      await WidgetService.pushUpdate(location: active, today: days.first, settings: settings);
    }
  } catch (_) {
    // Swallow errors in this headless isolate: there's no UI to report to,
    // and the next scheduled tick or manual tap will simply try again.
  }
}

/// Invoked by the native AppWidgetProvider when the user taps the
/// widget's manual refresh icon (see android_widget_integration/).
@pragma('vm:entry-point')
Future<void> widgetInteractivityCallback(Uri? uri) async {
  await _refreshWidgetData();
}

/// WorkManager's background isolate entry point for the periodic
/// auto-refresh task.
@pragma('vm:entry-point')
void workmanagerCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == BackgroundRefreshService.taskName) {
      await _refreshWidgetData();
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WidgetService.registerBackgroundCallback(widgetInteractivityCallback);
  await Workmanager().initialize(workmanagerCallbackDispatcher, isInDebugMode: false);

  final settings = await SettingsService.load();
  await BackgroundRefreshService.apply(settings);

  runApp(const ProviderScope(child: ShoreCastApp()));
}
