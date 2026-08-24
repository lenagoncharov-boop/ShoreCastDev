import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/location_model.dart';

class GeocodingService {
  static Future<List<CoastLocation>> search(String query) async {
    if (query.trim().length < 2) return [];

    final uri = Uri.parse(ApiConstants.geocodingBaseUrl).replace(queryParameters: {
      'name': query.trim(),
      'count': '10',
      'language': 'en',
      'format': 'json',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Geocoding API error ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (json['results'] as List?) ?? const [];

    return results.map((raw) {
      final m = raw as Map<String, dynamic>;
      final lat = (m['latitude'] as num).toDouble();
      final lon = (m['longitude'] as num).toDouble();
      final parts = [m['admin1'], m['country']].whereType<String>().where((e) => e.isNotEmpty);
      return CoastLocation(
        id: CoastLocation.idFor(lat, lon),
        name: m['name'] as String? ?? 'Unknown',
        region: parts.isEmpty ? null : parts.join(', '),
        lat: lat,
        lon: lon,
      );
    }).toList();
  }
}
