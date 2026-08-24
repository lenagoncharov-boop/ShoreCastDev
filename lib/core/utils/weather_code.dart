import 'package:flutter/material.dart';

/// Maps Open-Meteo's WMO weather codes to a Material icon + short label.
class WeatherCodeInfo {
  final IconData icon;
  final String label;

  const WeatherCodeInfo(this.icon, this.label);

  static WeatherCodeInfo forCode(int code) {
    switch (code) {
      case 0:
        return const WeatherCodeInfo(Icons.wb_sunny_rounded, 'Clear');
      case 1:
      case 2:
        return const WeatherCodeInfo(Icons.wb_cloudy_rounded, 'Partly cloudy');
      case 3:
        return const WeatherCodeInfo(Icons.cloud_rounded, 'Overcast');
      case 45:
      case 48:
        return const WeatherCodeInfo(Icons.foggy, 'Fog');
      case 51:
      case 53:
      case 55:
        return const WeatherCodeInfo(Icons.grain_rounded, 'Drizzle');
      case 56:
      case 57:
        return const WeatherCodeInfo(Icons.ac_unit_rounded, 'Freezing drizzle');
      case 61:
      case 63:
      case 65:
        return const WeatherCodeInfo(Icons.water_drop_rounded, 'Rain');
      case 66:
      case 67:
        return const WeatherCodeInfo(Icons.ac_unit_rounded, 'Freezing rain');
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherCodeInfo(Icons.ac_unit_rounded, 'Snow');
      case 80:
      case 81:
      case 82:
        return const WeatherCodeInfo(Icons.grain_rounded, 'Rain showers');
      case 85:
      case 86:
        return const WeatherCodeInfo(Icons.ac_unit_rounded, 'Snow showers');
      case 95:
        return const WeatherCodeInfo(Icons.thunderstorm_rounded, 'Thunderstorm');
      case 96:
      case 99:
        return const WeatherCodeInfo(Icons.thunderstorm_rounded, 'Thunderstorm + hail');
      default:
        return const WeatherCodeInfo(Icons.wb_cloudy_rounded, 'Unknown');
    }
  }
}
