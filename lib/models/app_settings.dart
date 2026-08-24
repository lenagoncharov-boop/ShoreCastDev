class AppSettings {
  final bool useMetricUnits;
  final int refreshIntervalMinutes;
  final bool widgetAutoRefreshEnabled;

  /// 'system' (follow the phone's language), or an explicit ISO 639-1
  /// code: 'en' | 'ru' | 'he'. See lib/l10n/ for the translations and
  /// lib/l10n/native_labels.dart for how 'system' gets resolved to a
  /// concrete language where there's no BuildContext to ask.
  final String languageCode;

  const AppSettings({
    this.useMetricUnits = true,
    this.refreshIntervalMinutes = 30,
    this.widgetAutoRefreshEnabled = true,
    this.languageCode = 'system',
  });

  AppSettings copyWith({
    bool? useMetricUnits,
    int? refreshIntervalMinutes,
    bool? widgetAutoRefreshEnabled,
    String? languageCode,
  }) =>
      AppSettings(
        useMetricUnits: useMetricUnits ?? this.useMetricUnits,
        refreshIntervalMinutes: refreshIntervalMinutes ?? this.refreshIntervalMinutes,
        widgetAutoRefreshEnabled: widgetAutoRefreshEnabled ?? this.widgetAutoRefreshEnabled,
        languageCode: languageCode ?? this.languageCode,
      );

  Map<String, dynamic> toJson() => {
        'useMetricUnits': useMetricUnits,
        'refreshIntervalMinutes': refreshIntervalMinutes,
        'widgetAutoRefreshEnabled': widgetAutoRefreshEnabled,
        'languageCode': languageCode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        useMetricUnits: json['useMetricUnits'] as bool? ?? true,
        refreshIntervalMinutes: json['refreshIntervalMinutes'] as int? ?? 30,
        widgetAutoRefreshEnabled: json['widgetAutoRefreshEnabled'] as bool? ?? true,
        languageCode: json['languageCode'] as String? ?? 'system',
      );
}
