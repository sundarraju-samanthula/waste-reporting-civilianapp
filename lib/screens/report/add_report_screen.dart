import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/report_controller.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final ReportController reportController = Get.put(
    ReportController(),
    permanent: true,
  );

  File? _image;

  String _areaType = 'Urban';
  String _accessibility = 'Easy';

  final _populationCtrl = TextEditingController();
  final _householdsCtrl = TextEditingController();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> _submitReport() async {
    if (_image == null) {
      Get.snackbar(
        "Error",
        "Please capture image",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      await reportController.submitReport(
        image: _image!,
        areaType: _areaType,
        population: int.parse(_populationCtrl.text),
        households: int.parse(_householdsCtrl.text),
        accessibility: _accessibility,
      );

      Get.snackbar(
        "Success",
        "Report Submitted Successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      _formKey.currentState!.reset();

      setState(() {
        _image = null;
      });
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Widget background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 39, 75, 207),
            Color.fromARGB(255, 29, 163, 26),
            Color.fromARGB(255, 12, 81, 9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget textField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,

        keyboardType: TextInputType.number,

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(
          labelText: hint,

          labelStyle: const TextStyle(color: Colors.white70),

          filled: true,

          fillColor: Colors.white.withOpacity(.15),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),

        validator: (v) {
          if (v == null || v.isEmpty) {
            return "Required";
          }
          return null;
        },
      ),
    );
  }

  Widget dropdown({
    required String value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      child: DropdownButtonFormField<String>(
        value: value,

        dropdownColor: const Color(0xff5f3dc4),

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(
          labelText: label,

          labelStyle: const TextStyle(color: Colors.white70),

          filled: true,

          fillColor: Colors.white.withOpacity(.15),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),

        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),

        onChanged: onChanged,
      ),
    );
  }

  Widget imagePicker() {
    return GestureDetector(
      onTap: _pickImage,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

          child: Container(
            height: 220,
            width: double.infinity,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              color: Colors.white.withOpacity(.15),

              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),

            child: _image == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 50),

                      SizedBox(height: 10),

                      Text(
                        "Tap to Capture Image",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  ),
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return Obx(
      () => reportController.isLoading.value
          ? const CircularProgressIndicator(color: Colors.white)
          : GestureDetector(
              onTap: _submitReport,

              child: Container(
                height: 55,

                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  gradient: const LinearGradient(
                    colors: [Color(0xff5A67D8), Color(0xff7F9CF5)],
                  ),
                ),

                child: const Center(
                  child: Text(
                    "Submit Report",

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      "Add Waste Report",

                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    imagePicker(),

                    const SizedBox(height: 20),

                    dropdown(
                      value: _areaType,
                      label: "Area Type",
                      items: const ["Urban", "Rural"],
                      onChanged: (v) {
                        setState(() {
                          _areaType = v!;
                        });
                      },
                    ),

                    textField(
                      hint: "Population Around",
                      controller: _populationCtrl,
                    ),

                    textField(
                      hint: "Nearby Households",
                      controller: _householdsCtrl,
                    ),

                    dropdown(
                      value: _accessibility,
                      label: "Accessibility",
                      items: const ["Easy", "Medium", "Hard"],
                      onChanged: (v) {
                        setState(() {
                          _accessibility = v!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    submitButton(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
