class AppSettings {
  final bool useMetricUnits;
  final int refreshIntervalMinutes;
  final bool widgetAutoRefreshEnabled;

  const AppSettings({
    this.useMetricUnits = true,
    this.refreshIntervalMinutes = 30,
    this.widgetAutoRefreshEnabled = true,
  });

  AppSettings copyWith({
    bool? useMetricUnits,
    int? refreshIntervalMinutes,
    bool? widgetAutoRefreshEnabled,
  }) =>
      AppSettings(
        useMetricUnits: useMetricUnits ?? this.useMetricUnits,
        refreshIntervalMinutes: refreshIntervalMinutes ?? this.refreshIntervalMinutes,
        widgetAutoRefreshEnabled: widgetAutoRefreshEnabled ?? this.widgetAutoRefreshEnabled,
      );

  Map<String, dynamic> toJson() => {
        'useMetricUnits': useMetricUnits,
        'refreshIntervalMinutes': refreshIntervalMinutes,
        'widgetAutoRefreshEnabled': widgetAutoRefreshEnabled,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        useMetricUnits: json['useMetricUnits'] as bool? ?? true,
        refreshIntervalMinutes: json['refreshIntervalMinutes'] as int? ?? 30,
        widgetAutoRefreshEnabled: json['widgetAutoRefreshEnabled'] as bool? ?? true,
      );
}
