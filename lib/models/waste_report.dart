class WasteReport {
  final String userId;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String areaType;
  final int population;
  final int households;
  final String accessibility;

  WasteReport({
    required this.userId,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.areaType,
    required this.population,
    required this.households,
    required this.accessibility,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'areaType': areaType,
      'population': population,
      'households': households,
      'accessibility': accessibility,
      'timestamp': DateTime.now(),
      'mlResult': {'severity': 'Pending', 'priorityScore': 0.0},
    };
  }
}
