import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  bool _loading = false;

  String _areaType = 'Urban';
  String _accessibility = 'Easy';

  final _populationCtrl = TextEditingController();
  final _householdsCtrl = TextEditingController();

  /* ---------------- Image Picker ---------------- */
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  /* ---------------- Location ---------------- */
  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /* ---------------- Submit Report ---------------- */
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate() || _image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Complete all fields")));
      return;
    }

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final position = await _getLocation();

      /* Upload Image */
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child(
        'waste_images/$fileName.jpg',
      );

      await ref.putFile(_image!);
      final imageUrl = await ref.getDownloadURL();

      /* Save Firestore Data */
      await FirebaseFirestore.instance.collection('waste_reports').add({
        'userId': user.uid,
        'imageUrl': imageUrl,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        'areaType': _areaType,
        'population': int.parse(_populationCtrl.text),
        'households': int.parse(_householdsCtrl.text),
        'accessibility': _accessibility,
        'timestamp': FieldValue.serverTimestamp(),
        'mlResult': {
          'severity': 'Pending',
          'priorityScore': 0.0,
          'status': 'Pending',
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Waste Report")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /* Image */
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image == null
                      ? const Center(child: Icon(Icons.camera_alt, size: 50))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              /* Area Type */
              DropdownButtonFormField(
                value: _areaType,
                decoration: const InputDecoration(
                  labelText: "Area Type",
                  border: OutlineInputBorder(),
                ),
                items: ['Urban', 'Rural']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _areaType = v!),
              ),

              const SizedBox(height: 12),

              /* Population */
              TextFormField(
                controller: _populationCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Population Around",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter population" : null,
              ),

              const SizedBox(height: 12),

              /* Households */
              TextFormField(
                controller: _householdsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nearby Households",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter households" : null,
              ),

              const SizedBox(height: 12),

              /* Accessibility */
              DropdownButtonFormField(
                value: _accessibility,
                decoration: const InputDecoration(
                  labelText: "Accessibility",
                  border: OutlineInputBorder(),
                ),
                items: ['Easy', 'Medium', 'Hard']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _accessibility = v!),
              ),

              const SizedBox(height: 24),

              /* Submit */
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Submit Report"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
