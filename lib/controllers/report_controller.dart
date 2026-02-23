import 'dart:io';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/report_services.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();
  final RxBool isLoading = false.obs;

  Future<void> submitReport({
    required File image,
    required String areaType,
    required int population,
    required int households,
    required String accessibility,
  }) async {
    try {
      isLoading.value = true;

      await _reportService.submitReport(
        image: image,
        areaType: areaType,
        population: population,
        households: households,
        accessibility: accessibility,
      );

      Get.snackbar(
        "Success",
        "Report submitted successfully. ML pending.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<QuerySnapshot> myReportsStream() {
    return _reportService.getMyReports();
  }

  Stream<DocumentSnapshot> reportStream(String reportId) {
    return FirebaseFirestore.instance
        .collection('reports')
        .doc(reportId)
        .snapshots();
  }
}
