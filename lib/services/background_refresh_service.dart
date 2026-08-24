import 'package:workmanager/workmanager.dart';
import '../models/app_settings.dart';

/// Registers/cancels the periodic WorkManager task that keeps the Android
/// home-screen widget's data fresh even while the app isn't open. Android
/// enforces a 15-minute floor on periodic WorkManager tasks, which is why
/// 15 is also the smallest option in the Settings screen.
class BackgroundRefreshService {
  static const String taskName = 'shorecast.widgetRefresh';

  static Future<void> apply(AppSettings settings) async {
    if (!settings.widgetAutoRefreshEnabled) {
      await Workmanager().cancelByUniqueName(taskName);
      return;
    }
    final minutes = settings.refreshIntervalMinutes < 15 ? 15 : settings.refreshIntervalMinutes;
    await Workmanager().cancelByUniqueName(taskName);
    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      frequency: Duration(minutes: minutes),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }
}
