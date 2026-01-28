import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class ReportController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Loading state
  final RxBool isLoading = false.obs;

  /// Submit waste report
  Future<void> submitReport({
    required File image,
    required String areaType,
    required int population,
    required int households,
    required String accessibility,
  }) async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        throw "User not authenticated";
      }

      // Get current location
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Upload image
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final Reference ref = _storage.ref().child('waste_images/$fileName.jpg');

      await ref.putFile(image);
      final String imageUrl = await ref.getDownloadURL();

      // Save report to Firestore
      await _db.collection('waste_reports').add({
        'userId': user.uid,
        'imageUrl': imageUrl,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        'areaType': areaType,
        'population': population,
        'households': households,
        'accessibility': accessibility,
        'timestamp': FieldValue.serverTimestamp(),
        'mlResult': {
          'severity': 'Pending',
          'priorityScore': 0.0,
          'status': 'Pending',
        },
      });

      Get.snackbar(
        "Success",
        "Waste report submitted",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch current user's reports
  Stream<QuerySnapshot> myReportsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('waste_reports')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
