/// Heuristic 1-5 "fishing condition" rating for inshore spin anglers,
/// inspired by Surfline-style star ratings but tuned for shore fishing
/// rather than surfing: moderate, well-organized swell that stirs bait
/// without turning the water into unfishable whitewash, combined with
/// manageable wind for lure control and casting accuracy.
///
/// This is a heuristic, not a scientific model — documented as such in
/// Settings > About.
enum RatingLevel { excellent, good, fair, poor }

class FishingRating {
  final double score; // 1.0 .. 5.0
  final String label; // English fallback only — for user-facing text use
  // RatingLevel + ratingLabel() from lib/l10n/native_labels.dart instead,
  // so it follows the app's selected language.
  final RatingLevel level;

  const FishingRating(this.score, this.label, this.level);

  static FishingRating compute({
    required double waveHeightM,
    required double windSpeedKmh,
    required double swellPeriodS,
  }) {
    double score = 5.0;

    // Wave height sweet spot ~0.3-0.9m for inshore spinning; too flat
    // reduces bait activity, too big means unsafe/unfishable whitewash.
    if (waveHeightM < 0.2) {
      score -= 1.0;
    } else if (waveHeightM > 1.2) {
      score -= (waveHeightM - 1.2) * 2.5;
    } else if (waveHeightM > 0.9) {
      score -= (waveHeightM - 0.9) * 1.2;
    }

    // Wind: light-moderate is fine, strong onshore wind ruins casting
    // and lure control.
    if (windSpeedKmh > 20) {
      score -= (windSpeedKmh - 20) / 10;
    }

    // Longer period swell = organized, cleaner surf; short period wind
    // chop is messy and harder to read.
    if (swellPeriodS < 5) {
      score -= 0.6;
    } else if (swellPeriodS >= 8) {
      score += 0.3;
    }

    score = score.clamp(1.0, 5.0);

    final String label;
    final RatingLevel level;
    if (score >= 4.2) {
      label = 'Excellent';
      level = RatingLevel.excellent;
    } else if (score >= 3.3) {
      label = 'Good';
      level = RatingLevel.good;
    } else if (score >= 2.3) {
      label = 'Fair';
      level = RatingLevel.fair;
    } else {
      label = 'Poor';
      level = RatingLevel.poor;
    }

    return FishingRating(double.parse(score.toStringAsFixed(1)), label, level);
  }
}
