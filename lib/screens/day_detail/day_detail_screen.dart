import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/utils/weather_code.dart';
import '../../models/daily_forecast.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_gradient_background.dart';
import '../home/widgets/hourly_chart_section.dart';
import '../home/widgets/hourly_table.dart';
import '../home/widgets/moon_sun_card.dart';

class DayDetailScreen extends ConsumerStatefulWidget {
  final List<DailyForecast> days;
  final int initialIndex;

  const DayDetailScreen({super.key, required this.days, required this.initialIndex});

  @override
  ConsumerState<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends ConsumerState<DayDetailScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final day = widget.days[_index];
    final weatherInfo = WeatherCodeInfo.forCode(day.weatherCode);
    final ratingColor = AppColors.ratingColor(day.dayRatingScore);

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(DateFormat('EEEE, d MMMM').format(day.date)),
          actions: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: _index > 0 ? () => setState(() => _index--) : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: _index < widget.days.length - 1 ? () => setState(() => _index++) : null,
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _DaySelectorRow(
                days: widget.days,
                selectedIndex: _index,
                onSelect: (i) => setState(() => _index = i),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Icon(weatherInfo.icon, size: 34, color: AppColors.accentAmber),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${UnitConverter.formatTemp(day.tempMin, metric: settings.useMetricUnits)} – '
                            '${UnitConverter.formatTemp(day.tempMax, metric: settings.useMetricUnits)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text(weatherInfo.label,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                            'Avg wave ${UnitConverter.formatHeight(day.avgWaveHeight, metric: settings.useMetricUnits)}'
                            ' · max ${UnitConverter.formatHeight(day.maxWaveHeight, metric: settings.useMetricUnits)}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: ratingColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: ratingColor.withOpacity(0.6)),
                      ),
                      child: Text(
                        day.dayRatingScore.toStringAsFixed(1),
                        style: TextStyle(color: ratingColor, fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              MoonSunCard(day: day),
              const SizedBox(height: 16),
              if (day.bestHour != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.goodGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.goodGreen.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.goodGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Best window: ${DateFormat('HH:mm').format(day.bestHour!.time)} · '
                          '${day.bestHour!.rating.label} (${day.bestHour!.rating.score.toStringAsFixed(1)})',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              HourlyChartSection(points: day.hourly, metricUnits: settings.useMetricUnits),
              const SizedBox(height: 20),
              const Text('Hourly breakdown', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              HourlyTable(day: day, metricUnits: settings.useMetricUnits),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaySelectorRow extends StatelessWidget {
  final List<DailyForecast> days;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _DaySelectorRow({required this.days, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == selectedIndex;
          return ChoiceChip(
            label: Text(i == 0 ? 'Today' : DateFormat('EEE d').format(days[i].date)),
            selected: selected,
            onSelected: (_) => onSelect(i),
            selectedColor: AppColors.accentCyan.withOpacity(0.25),
            backgroundColor: AppColors.panelNavy,
            labelStyle: TextStyle(
              color: selected ? AppColors.accentCyan : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(color: selected ? AppColors.accentCyan : AppColors.divider),
          );
        },
      ),
    );
  }
}
