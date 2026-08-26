import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ConditionMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;
  final Color? accent;
  final Widget? trailing;

  const ConditionMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
    this.accent,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ?? AppColors.accentCyan;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                // Wrap onto a second line at full size first -- the card
                // has the vertical room for it -- instead of shrinking the
                // font down to fit everything on one line. (FittedBox would
                // lay the text out unwrapped at its natural width before
                // scaling, which is what made this shrink far more than
                // necessary for something like "12 km/h · gusts 30".)
                Text(
                  value,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                if (subValue != null)
                  Text(
                    subValue!,
                    style: const TextStyle(fontSize: 11, color: AppColors.textFaint),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
