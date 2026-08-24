import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../services/background_refresh_service.dart';
import '../services/settings_service.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    state = await SettingsService.load();
    await BackgroundRefreshService.apply(state);
  }

  Future<void> setMetric(bool value) async {
    state = state.copyWith(useMetricUnits: value);
    await SettingsService.save(state);
  }

  Future<void> setRefreshInterval(int minutes) async {
    state = state.copyWith(refreshIntervalMinutes: minutes);
    await SettingsService.save(state);
    await BackgroundRefreshService.apply(state);
  }

  Future<void> setWidgetAutoRefresh(bool value) async {
    state = state.copyWith(widgetAutoRefreshEnabled: value);
    await SettingsService.save(state);
    await BackgroundRefreshService.apply(state);
  }

  Future<void> setLanguage(String languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await SettingsService.save(state);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
