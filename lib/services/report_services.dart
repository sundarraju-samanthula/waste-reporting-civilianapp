import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitReport({
    required File image,
    required String areaType,
    required int population,
    required int households,
    required String accessibility,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await _db.collection('reports').add({
      'user_id': user.uid,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'area_type': areaType,
      'population': population,
      'nearby_houses': households,
      'road_accessibility': accessibility,
      'ml_status': 'pending',
      'ml_priority': null,
      'ml_severity': null,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMyReports() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('reports')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
