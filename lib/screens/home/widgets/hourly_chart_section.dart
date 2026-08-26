import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/unit_converter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/sea_condition_point.dart';

/// Three stacked mini-charts sharing the same hourly x-axis, top to
/// bottom: wind speed (line/area), wave height (bars), tide level
/// (line/area). Mirrors the at-a-glance hourly trend graphs on
/// surfline.com.
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
    final tideValues = points.map((p) => p.seaLevelMsl).toList();
    final minTide = tideValues.reduce((a, b) => a < b ? a : b);
    final maxTide = tideValues.reduce((a, b) => a > b ? a : b);
    // Sea level barely moves within a day (often well under half a meter),
    // so pad the range rather than starting the axis at 0 -- otherwise the
    // line would look almost perfectly flat.
    final tideRange = (maxTide - minTide).abs() < 0.05 ? 0.05 : (maxTide - minTide);
    final tidePadding = tideRange * 0.3;

    // Shared Y-axis so the charts show a real value scale, not just the
    // hourly time axis along the bottom.
    // clamp()'s return type is inferred from its arguments; mixing an int
    // literal with double.infinity (as windMaxY's lower bound did) makes it
    // infer as num instead of double, which then fails to type-check
    // against the double-typed maxY/leftAxis() parameters below. Being
    // explicit here (declared type + toDouble()) avoids relying on that
    // inference at all.
    final double waveMaxY = (maxWave * 1.3).clamp(0.5, double.infinity).toDouble();
    final double windMaxY = (maxWind * 1.3).clamp(5, double.infinity).toDouble();
    final tideMinY = minTide - tidePadding;
    final tideMaxY = maxTide + tidePadding;

    AxisTitles leftAxis(double axisMax, double axisMin, String Function(double) format) {
      return AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 38,
          interval: ((axisMax - axisMin) / 3).clamp(0.01, double.infinity),
          getTitlesWidget: (value, meta) {
            if (value < axisMin - 0.001 || value > axisMax + 0.001) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                format(value),
                style: const TextStyle(fontSize: 9, color: AppColors.textFaint),
              ),
            );
          },
        ),
      );
    }

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
          Text(l10n.windSpeedChartTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: windMaxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: leftAxis(
                    windMaxY,
                    0,
                    (v) => UnitConverter.formatWindSpeed(v, metric: metricUnits).replaceAll(' ', ''),
                  ),
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
                        '${UnitConverter.formatWindSpeed(p.windSpeed, metric: metricUnits)}',
                        const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].windSpeed),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: AppColors.accentBlue,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.accentBlue.withOpacity(0.35),
                          AppColors.accentBlue.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.waveHeightChartTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: waveMaxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: leftAxis(
                    waveMaxY,
                    0,
                    (v) => UnitConverter.formatHeight(v, metric: metricUnits).replaceAll(' ', ''),
                  ),
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
                        toY: points[i].waveHeight,
                        color: AppColors.accentCyan,
                        width: (200 / points.length).clamp(2, 10),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.tideLevelChartTitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            l10n.tideCaption,
            style: const TextStyle(fontSize: 10, color: AppColors.textFaint),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: LineChart(
              LineChartData(
                minY: tideMinY,
                maxY: tideMaxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: leftAxis(
                    tideMaxY,
                    tideMinY,
                    (v) => UnitConverter.formatHeight(v, metric: metricUnits, decimals: 1).replaceAll(' ', ''),
                  ),
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
                        '${UnitConverter.formatHeight(p.seaLevelMsl, metric: metricUnits, decimals: 2)}',
                        const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].seaLevelMsl),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.25,
                    color: AppColors.goodGreen,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.goodGreen.withOpacity(0.35),
                          AppColors.goodGreen.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
