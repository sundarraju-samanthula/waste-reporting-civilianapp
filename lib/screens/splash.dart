import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.forward();

    _handleNavigation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final bool onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (!onboardingDone) {
      Get.offAllNamed('/onboarding');
      return;
    }

    await FirebaseAuth.instance.authStateChanges().first;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Widget background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 39, 75, 207),
            Color.fromARGB(255, 29, 163, 26),
            Color.fromARGB(255, 12, 81, 9),
          ],
        ),
      ),
    );
  }

  //-------------------------------- GLASS LOGO

  Widget logoCard() {
    return FadeTransition(
      opacity: fadeAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),

              color: Colors.white.withOpacity(.15),

              border: Border.all(color: Colors.white.withOpacity(.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //-------------------------------- ICON
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.2),
                  ),
                  child: const Icon(
                    Icons.recycling,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                //-------------------------------- APP NAME
                const Text(
                  "Recycle & Reward",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Smart Waste Management",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 25),

                //-------------------------------- LOADING
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------------- BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background(),

          Center(child: logoCard()),
        ],
      ),
    );
  }
}
