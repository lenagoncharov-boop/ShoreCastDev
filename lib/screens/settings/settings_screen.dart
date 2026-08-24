import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_gradient_background.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Settings')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionLabel('Units'),
              _SettingsCard(
                child: SwitchListTile(
                  value: settings.useMetricUnits,
                  onChanged: notifier.setMetric,
                  title: const Text('Metric units'),
                  subtitle: Text(
                    settings.useMetricUnits
                        ? 'Meters, km/h, °C'
                        : 'Feet, knots, °F',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
              ),
              const _SectionLabel('Refresh'),
              _SettingsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
                      child: Text('Auto-refresh interval', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final minutes in refreshIntervalOptionsMinutes)
                            ChoiceChip(
                              label: Text(minutes < 60 ? '$minutes min' : '${minutes ~/ 60} h'),
                              selected: settings.refreshIntervalMinutes == minutes,
                              onSelected: (_) => notifier.setRefreshInterval(minutes),
                              selectedColor: AppColors.accentCyan.withOpacity(0.25),
                              backgroundColor: AppColors.panelNavyLight,
                              labelStyle: TextStyle(
                                color: settings.refreshIntervalMinutes == minutes
                                    ? AppColors.accentCyan
                                    : AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    SwitchListTile(
                      value: settings.widgetAutoRefreshEnabled,
                      onChanged: notifier.setWidgetAutoRefresh,
                      title: const Text('Auto-refresh home-screen widget'),
                      subtitle: const Text(
                        'Uses the interval above. You can always tap the widget\'s refresh icon manually.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const _SectionLabel('About the data'),
              _SettingsCard(
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ShoreCast uses free, open weather and marine data:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Open-Meteo Marine Weather API — wave height, swell, wind waves, sea temperature\n'
                        '• Open-Meteo Weather API — air temperature, wind, sunrise/sunset, UV, cloud cover\n'
                        '• Open-Meteo Geocoding API — coastal location search\n'
                        '• Moon phase is computed locally from an astronomical formula (no API call)',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tide note',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'There is currently no free, key-less, worldwide source of real harmonic tide '
                        'predictions. The tide trend shown (rising/falling) is derived from Open-Meteo\'s '
                        'blended sea-level signal, which is a good qualitative guide but not a precise '
                        'tide-table time or height — treat it as an estimate.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      AppInfo.buildLabel,
                      style: const TextStyle(
                        color: AppColors.textFaint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppInfo.buildNote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textFaint, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: AppColors.textFaint,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
