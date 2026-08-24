import 'dart:math' as math;

/// Pure-Dart moon phase calculator. No network call needed.
///
/// Uses the mean synodic month (29.530588853 days) measured from a known
/// new moon reference (2000-01-06 18:14 UTC). Accurate to well within a
/// day, which is more than sufficient for a qualitative fishing app.
enum MoonPhaseName {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

class MoonPhaseInfo {
  final double age; // days since last new moon, 0..29.53
  final double illumination; // 0.0..1.0
  final MoonPhaseName phase;

  const MoonPhaseInfo({
    required this.age,
    required this.illumination,
    required this.phase,
  });

  String get label {
    switch (phase) {
      case MoonPhaseName.newMoon:
        return 'New Moon';
      case MoonPhaseName.waxingCrescent:
        return 'Waxing Crescent';
      case MoonPhaseName.firstQuarter:
        return 'First Quarter';
      case MoonPhaseName.waxingGibbous:
        return 'Waxing Gibbous';
      case MoonPhaseName.fullMoon:
        return 'Full Moon';
      case MoonPhaseName.waningGibbous:
        return 'Waning Gibbous';
      case MoonPhaseName.lastQuarter:
        return 'Last Quarter';
      case MoonPhaseName.waningCrescent:
        return 'Waning Crescent';
    }
  }

  /// Material glyph-free emoji fallback isn't used in-app (we draw a
  /// custom painter), but this is handy for widget text / debug.
  String get symbol {
    switch (phase) {
      case MoonPhaseName.newMoon:
        return '\u{1F311}';
      case MoonPhaseName.waxingCrescent:
        return '\u{1F312}';
      case MoonPhaseName.firstQuarter:
        return '\u{1F313}';
      case MoonPhaseName.waxingGibbous:
        return '\u{1F314}';
      case MoonPhaseName.fullMoon:
        return '\u{1F315}';
      case MoonPhaseName.waningGibbous:
        return '\u{1F316}';
      case MoonPhaseName.lastQuarter:
        return '\u{1F317}';
      case MoonPhaseName.waningCrescent:
        return '\u{1F318}';
    }
  }
}

class MoonPhaseCalculator {
  MoonPhaseCalculator._();

  static const double _synodicMonth = 29.530588853;
  static final DateTime _knownNewMoonUtc = DateTime.utc(2000, 1, 6, 18, 14);

  static MoonPhaseInfo forDate(DateTime date) {
    final utc = date.toUtc();
    final daysSince = utc.difference(_knownNewMoonUtc).inMinutes / (60 * 24);
    double age = daysSince % _synodicMonth;
    if (age < 0) age += _synodicMonth;

    final illumination = (1 - math.cos(2 * math.pi * age / _synodicMonth)) / 2;

    final MoonPhaseName phase;
    final frac = age / _synodicMonth;
    if (frac < 0.03 || frac >= 0.97) {
      phase = MoonPhaseName.newMoon;
    } else if (frac < 0.22) {
      phase = MoonPhaseName.waxingCrescent;
    } else if (frac < 0.28) {
      phase = MoonPhaseName.firstQuarter;
    } else if (frac < 0.47) {
      phase = MoonPhaseName.waxingGibbous;
    } else if (frac < 0.53) {
      phase = MoonPhaseName.fullMoon;
    } else if (frac < 0.72) {
      phase = MoonPhaseName.waningGibbous;
    } else if (frac < 0.78) {
      phase = MoonPhaseName.lastQuarter;
    } else {
      phase = MoonPhaseName.waningCrescent;
    }

    return MoonPhaseInfo(age: age, illumination: illumination, phase: phase);
  }
}
