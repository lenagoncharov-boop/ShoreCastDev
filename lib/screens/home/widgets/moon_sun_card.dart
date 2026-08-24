import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/daily_forecast.dart';
import '../../../widgets/moon_phase_icon.dart';

class MoonSunCard extends StatelessWidget {
  final DailyForecast day;

  const MoonSunCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final timeFmt = DateFormat('HH:mm');
    final moon = day.moonPhase;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SunColumn(
              icon: Icons.wb_twilight_rounded,
              label: 'Sunrise',
              time: timeFmt.format(day.sunrise),
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _SunColumn(
              icon: Icons.nights_stay_rounded,
              label: 'Sunset',
              time: timeFmt.format(day.sunset),
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: Column(
              children: [
                MoonPhaseIcon(phase: moon, size: 32),
                const SizedBox(height: 6),
                Text(
                  moon.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                Text(
                  '${(moon.illumination * 100).toStringAsFixed(0)}% lit',
                  style: const TextStyle(fontSize: 10, color: AppColors.textFaint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SunColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;

  const _SunColumn({required this.icon, required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentAmber, size: 22),
        const SizedBox(height: 6),
        Text(time, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
