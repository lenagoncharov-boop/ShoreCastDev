import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../core/utils/compass_utils.dart';
import '../core/utils/unit_converter.dart';
import '../models/app_settings.dart';
import '../models/daily_forecast.dart';
import '../models/location_model.dart';
import '../models/sea_condition_point.dart';

/// Bridges the freshest sea-condition data into the native Android
/// home-screen widget (see android_widget_integration/ for the Kotlin
/// side: SeaConditionWidgetProvider renders it, WidgetConfigureActivity
/// lets the user pick which metric is the headline).
///
/// All display formatting (icons/emoji, units, labels) happens here in
/// Dart. Every metric gets three flavors pushed: a bare *value* (for when
/// it's the chosen headline), an icon-prefixed *line* (for the small
/// info grid), and a *subtitle* (caption under the headline number).
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
        : TideTrend.slack;

    final metric = settings.useMetricUnits;
    final rating = point.rating;

    final String ratingBucket;
    if (rating.score >= 4) {
      ratingBucket = 'good';
    } else if (rating.score >= 2.5) {
      ratingBucket = 'fair';
    } else {
      ratingBucket = 'poor';
    }

    final String tideArrow;
    switch (trend) {
      case TideTrend.rising:
        tideArrow = '⬆️';
        break;
      case TideTrend.falling:
        tideArrow = '⬇️';
        break;
      case TideTrend.slack:
        tideArrow = '➡️';
        break;
    }

    final waveHeight = UnitConverter.formatHeight(point.waveHeight, metric: metric);
    final windSpeed = UnitConverter.formatWindSpeed(point.windSpeed, metric: metric);
    final windGusts = UnitConverter.formatWindSpeed(point.windGusts, metric: metric);
    final airTemp = UnitConverter.formatTemp(point.airTemp, metric: metric);
    final waterTemp = UnitConverter.formatTemp(point.seaSurfaceTemp, metric: metric);
    final windDir = CompassUtils.labelFor(point.windDirection);
    final swellDir = CompassUtils.labelFor(point.swellDirection);

    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyLocationLine, '📍 ${location.displayName}');
    await HomeWidget.saveWidgetData<String>(WidgetConstants.keyRatingLabel, rating.label);
    await HomeWidget.saveWidgetData<String>(WidgetConstants.keyRatingBucket, ratingBucket);
    await HomeWidget.saveWidgetData<String>(
        WidgetConstants.keyUpdatedLine, 'Updated ${DateFormat('HH:mm').format(now)}');
    await HomeWidget.saveWidgetData<bool>(WidgetConstants.keyUnits, metric);

    Future<void> pushMetric(String id, String value, String line, String subtitle) async {
      await HomeWidget.saveWidgetData<String>(WidgetConstants.keyMetricValue(id), value);
      await HomeWidget.saveWidgetData<String>(WidgetConstants.keyMetricLine(id), line);
      await HomeWidget.saveWidgetData<String>(WidgetConstants.keyMetricSubtitle(id), subtitle);
    }

    await pushMetric(
      'wave',
      waveHeight,
      '🌊 $waveHeight',
      '${UnitConverter.formatPeriod(point.swellPeriod)} period swell · $swellDir',
    );
    await pushMetric(
      'wind',
      windSpeed,
      '💨 $windSpeed $windDir',
      '$windDir · gusts $windGusts',
    );
    await pushMetric(
      'tide',
      trend.label,
      '$tideArrow ${trend.label}',
      'Sea-level trend (estimate)',
    );
    await pushMetric('air', airTemp, '🌡️ $airTemp', 'Air temperature');
    await pushMetric('water', waterTemp, '💧 $waterTemp', 'Water temperature');

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
