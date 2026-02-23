import 'package:cloud_firestore/cloud_firestore.dart';

class WasteReport {
  final String userId;
  final double latitude;
  final double longitude;
  final String areaType;
  final int population;
  final int nearbyHouses;
  final String roadAccessibility;
  final bool waterBodyNearby;
  final bool recurringLocation;
  final String wasteSpreadSize;
  final String mlStatus;
  final Timestamp createdAt;

  WasteReport({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.areaType,
    required this.population,
    required this.nearbyHouses,
    required this.roadAccessibility,
    required this.waterBodyNearby,
    required this.recurringLocation,
    required this.wasteSpreadSize,
    required this.mlStatus,
    required this.createdAt,
  });

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'area_type': areaType,
      'population': population,
      'nearby_houses': nearbyHouses,
      'road_accessibility': roadAccessibility,
      'water_body_nearby': waterBodyNearby,
      'recurring_location': recurringLocation,
      'waste_spread_size': wasteSpreadSize,
      'ml_status': mlStatus,
      'created_at': createdAt,
    };
  }

  /// Create model from Firestore document
  factory WasteReport.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return WasteReport(
      userId: data['user_id'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      areaType: data['area_type'] ?? '',
      population: data['population'] ?? 0,
      nearbyHouses: data['nearby_houses'] ?? 0,
      roadAccessibility: data['road_accessibility'] ?? '',
      waterBodyNearby: data['water_body_nearby'] ?? false,
      recurringLocation: data['recurring_location'] ?? false,
      wasteSpreadSize: data['waste_spread_size'] ?? '',
      mlStatus: data['ml_status'] ?? 'pending',
      createdAt: data['created_at'] ?? Timestamp.now(),
    );
  }
}
