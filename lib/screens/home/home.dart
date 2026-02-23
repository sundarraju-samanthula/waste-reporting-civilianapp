import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  void logoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xff5A67D8),
      onConfirm: () {
        Get.back();
        authController.logout();
      },
    );
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

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 25, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome 👋",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),

              Text(
                "Smart Waste System",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.2),
            ),
            child: IconButton(
              onPressed: logoutDialog,
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget heroSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 300,
          child: Lottie.asset(
            "assets/animation/home.json",
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          "Keep Your City Clean",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 6),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Report waste and help authorities maintain a clean environment.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget addReportCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: GestureDetector(
        onTap: () => Get.toNamed('/add-report'),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

            child: Container(
              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                color: Colors.white.withOpacity(.15),

                border: Border.all(color: Colors.white.withOpacity(.25)),
              ),

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.2),
                    ),

                    child: const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Add Waste Report",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Capture waste using camera and location",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                      gradient: const LinearGradient(
                        colors: [Color(0xff5A67D8), Color(0xff7F9CF5)],
                      ),
                    ),

                    child: const Text(
                      "Start Reporting",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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

          SingleChildScrollView(
            child: Column(
              children: [
                header(),

                const SizedBox(height: 10),

                heroSection(),

                const SizedBox(height: 10),

                addReportCard(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
