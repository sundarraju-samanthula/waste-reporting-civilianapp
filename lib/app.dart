import 'package:civilianapp/controllers/auth_controller.dart';
import 'package:civilianapp/screens/home/home.dart';
import 'package:civilianapp/screens/onboarding.dart';
import 'package:civilianapp/screens/report/add_report_screen.dart';
import 'package:civilianapp/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

class WasteApp extends StatelessWidget {
  const WasteApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Reporting App',

      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),

      initialRoute: '/splash',

      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/add-report', page: () => const AddReportScreen()),
      ],
    );
  }
}
