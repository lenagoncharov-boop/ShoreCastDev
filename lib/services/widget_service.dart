import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../core/utils/unit_converter.dart';
import '../models/app_settings.dart';
import '../models/daily_forecast.dart';
import '../models/sea_condition_point.dart';
import '../models/location_model.dart';

/// Bridges the freshest sea-condition data into the native Android
/// home-screen widget (see android_widget_integration/ for the Kotlin
/// AppWidgetProvider that reads these keys).
class WidgetService {
  static Future<void> pushUpdate({
    required CoastLocation location,
    required DailyForecast today,
    required AppSettings settings,
  }) async {
    final now = DateTime.now();
    // Nearest hour to "now" from today's hourly series.
    final point = today.hourly.isEmpty
        ? null
        : today.hourly.reduce((a, b) =>
            (a.time.difference(now).abs()) < (b.time.difference(now).abs()) ? a : b);

    if (point == null) return;

    final idx = today.hourly.indexOf(point);
    final trend = today.hourlyTideTrend.isNotEmpty && idx < today.hourlyTideTrend.length
        ? today.hourlyTideTrend[idx]
        : null;

    final metric = settings.useMetricUnits;

    await HomeWidget.saveWidgetData<String>(WidgetConstants.keyLocationName, location.displayName);
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyWaveHeight, UnitConverter.formatHeight(point.waveHeight, metric: metric));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyWavePeriod, UnitConverter.formatPeriod(point.wavePeriod));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keySwellDirection, point.swellDirection.toStringAsFixed(0));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyWindSpeed, UnitConverter.formatWindSpeed(point.windSpeed, metric: metric));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyWindDirection, point.windDirection.toStringAsFixed(0));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyAirTemp, UnitConverter.formatTemp(point.airTemp, metric: metric));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyWaterTemp, UnitConverter.formatTemp(point.seaSurfaceTemp, metric: metric));
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyTideTrend, trend?.label ?? '--');
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyRatingLabel, point.rating.label);
    await HomeWidget.saveWidgetData<double>(
        WidgetConstants.keyRatingScore, point.rating.score);
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyUpdatedAt, DateFormat('HH:mm').format(now));
    await HomeWidget.saveWidgetData<bool>(WidgetConstants.keyUnits, metric);

    await HomeWidget.updateWidget(
      androidName: WidgetConstants.androidWidgetName,
      qualifiedAndroidName: 'com.shorecast.shorecast_app.${WidgetConstants.androidWidgetName}',
    );
  }

  /// Registers the callback invoked by the native widget's manual refresh
  /// button (tap -> broadcast -> headless Dart callback -> fresh fetch ->
  /// pushUpdate -> widget redraw). Call once from main().
  static Future<void> registerBackgroundCallback(Future<void> Function(Uri? uri) callback) async {
    await HomeWidget.registerInteractivityCallback(callback);
  }
}
