import 'package:flutter/material.dart';

/// Surfline-inspired dark ocean theme: deep navy backgrounds, bright cyan
/// accent, glassy cards. Matches the app's launcher icon palette.
class AppColors {
  AppColors._();

  static const Color deepNavy = Color(0xFF071A33);
  static const Color oceanNavy = Color(0xFF0B2545);
  static const Color panelNavy = Color(0xFF10305C);
  static const Color panelNavyLight = Color(0xFF16407A);
  static const Color accentCyan = Color(0xFF34D3F0);
  static const Color accentBlue = Color(0xFF2E7BFA);
  static const Color accentAmber = Color(0xFFFFB74D);
  static const Color goodGreen = Color(0xFF4CD684);
  static const Color fairYellow = Color(0xFFE0C93A);
  static const Color poorRed = Color(0xFFEF6461);
  static const Color textPrimary = Color(0xFFF3F8FF);
  static const Color textSecondary = Color(0xFFA9C0E0);
  static const Color textFaint = Color(0xFF6E88AE);
  static const Color divider = Color(0x33FFFFFF);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A2A52), Color(0xFF071A33)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [panelNavyLight, panelNavy],
  );

  /// Color scale for the 1-5 "fishing condition" rating.
  static Color ratingColor(double score) {
    if (score >= 4) return goodGreen;
    if (score >= 2.5) return fairYellow;
    return poorRed;
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.deepNavy,
      primaryColor: AppColors.accentCyan,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.accentCyan,
        secondary: AppColors.accentBlue,
        surface: AppColors.panelNavy,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.panelNavy,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dividerColor: AppColors.divider,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.oceanNavy,
        selectedItemColor: AppColors.accentCyan,
        unselectedItemColor: AppColors.textFaint,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.accentCyan : AppColors.textFaint,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accentCyan.withOpacity(0.4)
              : AppColors.panelNavyLight,
        ),
      ),
      listTileTheme: const ListTileThemeData(iconColor: AppColors.accentCyan),
    );
  }
}
