import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_gradient_background.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionLabel(l10n.unitsSection),
              _SettingsCard(
                child: SwitchListTile(
                  value: settings.useMetricUnits,
                  onChanged: notifier.setMetric,
                  title: Text(l10n.metricUnits),
                  subtitle: Text(
                    settings.useMetricUnits ? l10n.unitsMetricSubtitle : l10n.unitsImperialSubtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ),
              ),
              _SectionLabel(l10n.languageSection),
              _SettingsCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      _LanguageOption(
                        title: l10n.languageSystem,
                        subtitle: l10n.languageSystemSubtitle,
                        selected: settings.languageCode == 'system',
                        onTap: () => notifier.setLanguage('system'),
                      ),
                      _LanguageOption(
                        title: 'Русский',
                        selected: settings.languageCode == 'ru',
                        onTap: () => notifier.setLanguage('ru'),
                      ),
                      _LanguageOption(
                        title: 'English',
                        selected: settings.languageCode == 'en',
                        onTap: () => notifier.setLanguage('en'),
                      ),
                      _LanguageOption(
                        title: 'עברית',
                        selected: settings.languageCode == 'he',
                        onTap: () => notifier.setLanguage('he'),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
              _SectionLabel(l10n.refreshSection),
              _SettingsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                      child: Text(l10n.autoRefreshInterval, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final minutes in refreshIntervalOptionsMinutes)
                            ChoiceChip(
                              label: Text(minutes < 60 ? l10n.minutesShort(minutes) : l10n.hoursShort(minutes ~/ 60)),
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
                      title: Text(l10n.widgetAutoRefresh),
                      subtitle: Text(
                        l10n.widgetAutoRefreshSubtitle,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              _SectionLabel(l10n.aboutDataSection),
              _SettingsCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aboutDataIntro,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.aboutDataSources,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.tideNoteTitle,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.tideNoteBody,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
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

class _LanguageOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool isLast;

  const _LanguageOption({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          trailing: Icon(
            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.accentCyan : AppColors.textFaint,
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
      ],
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
