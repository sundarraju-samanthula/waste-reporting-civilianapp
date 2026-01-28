import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/report_controller.dart';

class MyReportsScreen extends StatelessWidget {
  MyReportsScreen({super.key});

  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Reports")),
      body: StreamBuilder(
        stream: reportController.myReportsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reports submitted yet"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "Severity: ${data['mlResult']['severity']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Area: ${data['areaType']} • ${data['accessibility']}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
