import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/sea_condition_point.dart';
import '../../providers/forecast_provider.dart';
import '../../providers/locations_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_gradient_background.dart';
import '../../widgets/compass_gauge.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import '../day_detail/day_detail_screen.dart';
import '../locations/location_picker_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/condition_metric_card.dart';
import 'widgets/current_conditions_header.dart';
import 'widgets/hourly_chart_section.dart';
import 'widgets/hourly_table.dart';
import 'widgets/moon_sun_card.dart';
import 'widgets/seven_day_strip.dart';
import 'widgets/tide_trend_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _refreshTimer;
  int _timerIntervalMinutes = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncRefreshTimer();
  }

  void _syncRefreshTimer() {
    final minutes = ref.read(settingsProvider).refreshIntervalMinutes;
    if (minutes == _timerIntervalMinutes) return;
    _timerIntervalMinutes = minutes;
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(Duration(minutes: minutes), (_) {
      ref.invalidate(forecastProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild the timer if the user changes the refresh interval in Settings.
    ref.listen(settingsProvider, (previous, next) {
      if (previous?.refreshIntervalMinutes != next.refreshIntervalMinutes) {
        _syncRefreshTimer();
      }
    });

    final location = ref.watch(activeLocationProvider);
    final settings = ref.watch(settingsProvider);
    final forecastAsync = ref.watch(forecastProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ShoreCast'),
                const SizedBox(width: 6),
                const Icon(Icons.expand_more_rounded, size: 20),
              ],
            ),
          ),
          actions: [
            IconButton(
              tooltip: l10n.refreshNowTooltip,
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => ref.invalidate(forecastProvider),
            ),
            IconButton(
              tooltip: l10n.settingsTooltip,
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: forecastAsync.when(
            loading: () => const LoadingView(),
            error: (err, _) => ErrorView(
              message: err.toString(),
              onRetry: () => ref.invalidate(forecastProvider),
            ),
            data: (days) {
              if (days.isEmpty) {
                return ErrorView(message: l10n.noForecastData, onRetry: _noop);
              }
              final today = days.first;
              final now = DateTime.now();
              final currentIndex = _closestHourIndex(today.hourly, now);
              final SeaConditionPoint current = today.hourly[currentIndex];

              return RefreshIndicator(
                color: AppColors.accentCyan,
                backgroundColor: AppColors.panelNavy,
                onRefresh: () async => ref.invalidate(forecastProvider),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    CurrentConditionsHeader(
                      location: location,
                      current: current,
                      metricUnits: settings.useMetricUnits,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Two rows of two cards. Each row is wrapped in
                          // IntrinsicHeight + stretch so both cards in it
                          // share the taller card's height, and neither one
                          // is squeezed into a fixed aspect ratio the way a
                          // GridView.count cell would be -- that's what was
                          // causing the "BOTTOM OVERFLOWED" warnings when a
                          // card's text needed more room than a fixed-ratio
                          // cell allowed.
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ConditionMetricCard(
                                    icon: Icons.waves_rounded,
                                    label: l10n.swellLabel,
                                    value:
                                        '${current.swellHeight.toStringAsFixed(1)} m @ ${current.swellPeriod.toStringAsFixed(0)}s',
                                    subValue: l10n.windWavesSubvalue('${current.windWaveHeight.toStringAsFixed(1)} m'),
                                    accent: AppColors.accentCyan,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ConditionMetricCard(
                                    icon: Icons.air_rounded,
                                    label: l10n.windLabel,
                                    value:
                                        '${current.windSpeed.toStringAsFixed(0)} km/h · gusts ${current.windGusts.toStringAsFixed(0)}',
                                    accent: AppColors.accentBlue,
                                    trailing: CompassGauge(
                                      directionDegrees: current.windDirection,
                                      size: 30,
                                      color: AppColors.accentBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ConditionMetricCard(
                                    icon: Icons.thermostat_rounded,
                                    label: l10n.airWaterTemp,
                                    value:
                                        '${current.airTemp.toStringAsFixed(0)}° / ${current.seaSurfaceTemp.toStringAsFixed(0)}°C',
                                    accent: AppColors.accentAmber,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ConditionMetricCard(
                                    icon: Icons.wb_sunny_outlined,
                                    label: l10n.uvIndexLabel,
                                    value: current.uvIndex.toStringAsFixed(1),
                                    subValue: l10n.cloudCoverSubvalue(current.cloudCover.toStringAsFixed(0)),
                                    accent: AppColors.accentAmber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          TideTrendCard(day: today, currentHourIndex: currentIndex),
                          const SizedBox(height: 10),
                          MoonSunCard(day: today),
                          const SizedBox(height: 16),
                          HourlyChartSection(
                            points: today.hourly,
                            metricUnits: settings.useMetricUnits,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.hourlyBreakdown, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HourlyTable(day: today, metricUnits: settings.useMetricUnits),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.sevenDayOutlook, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SevenDayStrip(
                        days: days,
                        metricUnits: settings.useMetricUnits,
                        onSelectDay: (index) {
                          ref.read(selectedDayIndexProvider.notifier).state = index;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DayDetailScreen(days: days, initialIndex: index),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static int _closestHourIndex(List<SeaConditionPoint> hourly, DateTime now) {
    if (hourly.isEmpty) return 0;
    var bestIndex = 0;
    var bestDiff = hourly.first.time.difference(now).abs();
    for (var i = 1; i < hourly.length; i++) {
      final diff = hourly[i].time.difference(now).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  static void _noop() {}
}
