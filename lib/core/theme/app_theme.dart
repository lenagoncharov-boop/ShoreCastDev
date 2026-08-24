import 'package:flutter/material.dart';

/// Vivid ocean-blue theme lifted straight from the app's launcher icon:
/// a bright, energetic azure background (not a dark/gloomy navy) with
/// richer medium-blue cards floating on top, same layered look as the
/// icon's weather panel over the sunset-sea photo.
class AppColors {
  AppColors._();

  static const Color deepNavy = Color(0xFF01439A);
  static const Color oceanNavy = Color(0xFF013B84);
  static const Color panelNavy = Color(0xFF00458F);
  static const Color panelNavyLight = Color(0xFF0072BE);
  static const Color accentCyan = Color(0xFF3DD9F5);
  static const Color accentBlue = Color(0xFF2E9BFA);
  static const Color accentAmber = Color(0xFFFFCB4D);
  static const Color goodGreen = Color(0xFF4CD684);
  static const Color fairYellow = Color(0xFFE0C93A);
  static const Color poorRed = Color(0xFFEF6461);
  static const Color textPrimary = Color(0xFFF3F8FF);
  static const Color textSecondary = Color(0xFFB9DCF7);
  static const Color textFaint = Color(0xFF89B4E0);
  static const Color divider = Color(0x3DFFFFFF);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0288E5), deepNavy],
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
