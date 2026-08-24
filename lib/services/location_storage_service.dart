import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/location_model.dart';

class LocationStorageService {
  static Future<List<CoastLocation>> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(StorageKeys.savedLocations);
    if (raw == null || raw.isEmpty) {
      return [
        const CoastLocation(
          id: '${DefaultLocation.lat}_${DefaultLocation.lon}',
          name: DefaultLocation.name,
          lat: DefaultLocation.lat,
          lon: DefaultLocation.lon,
          isFavorite: true,
        ),
      ];
    }
    return raw.map((s) => CoastLocation.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  static Future<void> saveAll(List<CoastLocation> locations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      StorageKeys.savedLocations,
      locations.map((l) => jsonEncode(l.toJson())).toList(),
    );
  }

  static Future<String?> loadActiveLocationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.activeLocationId);
  }

  static Future<void> saveActiveLocationId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.activeLocationId, id);
  }
}
