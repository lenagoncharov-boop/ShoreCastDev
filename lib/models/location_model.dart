class CoastLocation {
  final String id;
  final String name;
  final String? region;
  final double lat;
  final double lon;
  final bool isFavorite;

  const CoastLocation({
    required this.id,
    required this.name,
    this.region,
    required this.lat,
    required this.lon,
    this.isFavorite = false,
  });

  String get displayName => region == null || region!.isEmpty ? name : '$name, $region';

  CoastLocation copyWith({bool? isFavorite}) => CoastLocation(
        id: id,
        name: name,
        region: region,
        lat: lat,
        lon: lon,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'region': region,
        'lat': lat,
        'lon': lon,
        'isFavorite': isFavorite,
      };

  factory CoastLocation.fromJson(Map<String, dynamic> json) => CoastLocation(
        id: json['id'] as String,
        name: json['name'] as String,
        region: json['region'] as String?,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        isFavorite: json['isFavorite'] as bool? ?? false,
      );

  static String idFor(double lat, double lon) =>
      '${lat.toStringAsFixed(3)}_${lon.toStringAsFixed(3)}';
}

/// A short curated list of well-known inshore coasts shown as quick-picks
/// in the location screen, in addition to free-text search.
const List<CoastLocation> suggestedCoasts = [
  CoastLocation(id: '32.162_34.794', name: 'Herzliya', region: 'Israel', lat: 32.1624, lon: 34.7936),
  CoastLocation(id: '32.083_34.775', name: 'Tel Aviv', region: 'Israel', lat: 32.0853, lon: 34.7818),
  CoastLocation(id: '31.267_34.267', name: 'Ashkelon', region: 'Israel', lat: 31.6693, lon: 34.5715),
  CoastLocation(id: '32.794_34.989', name: 'Haifa', region: 'Israel', lat: 32.7940, lon: 34.9896),
  CoastLocation(id: '36.567_-121.909', name: 'Monterey', region: 'USA', lat: 36.5673, lon: -121.9090),
  CoastLocation(id: '50.395_-4.142', name: 'Plymouth', region: 'UK', lat: 50.3755, lon: -4.1427),
];
