import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/sea_condition_point.dart';

/// Two stacked mini-charts: wave height (line/area) and wind speed
/// (bars), sharing the same hourly x-axis. Mirrors the at-a-glance
/// hourly trend graphs on surfline.com.
class HourlyChartSection extends StatelessWidget {
  final List<SeaConditionPoint> points;
  final bool metricUnits;

  const HourlyChartSection({super.key, required this.points, required this.metricUnits});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    final maxWave = points.map((p) => p.waveHeight).reduce((a, b) => a > b ? a : b);
    final maxWind = points.map((p) => p.windSpeed).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.waveHeightChartTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: (maxWave * 1.3).clamp(0.5, double.infinity),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: (points.length / 6).clamp(1, double.infinity),
                      getTitlesWidget: (value, meta) {
                        final i = value.round();
                        if (i < 0 || i >= points.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('HH').format(points[i].time),
                            style: const TextStyle(fontSize: 10, color: AppColors.textFaint),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.panelNavyLight,
                    getTooltipItems: (spots) => spots.map((s) {
                      final i = s.x.round().clamp(0, points.length - 1);
                      final p = points[i];
                      return LineTooltipItem(
                        '${DateFormat('HH:mm').format(p.time)}\n'
                        '${UnitConverter.formatHeight(p.waveHeight, metric: metricUnits)}',
                        const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].waveHeight),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: AppColors.accentCyan,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.accentCyan.withOpacity(0.35),
                          AppColors.accentCyan.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.windSpeedChartTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: (maxWind * 1.3).clamp(5, double.infinity),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: (points.length / 6).clamp(1, double.infinity),
                      getTitlesWidget: (value, meta) {
                        final i = value.round();
                        if (i < 0 || i >= points.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat('HH').format(points[i].time),
                            style: const TextStyle(fontSize: 10, color: AppColors.textFaint),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < points.length; i++)
                    BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: points[i].windSpeed,
                        color: AppColors.accentBlue,
                        width: (200 / points.length).clamp(2, 10),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
