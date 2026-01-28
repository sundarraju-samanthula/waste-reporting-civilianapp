import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Auth Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// Home
import 'screens/home/home_screen.dart';

// Report Screens
import 'screens/report/add_report_screen.dart';
import 'screens/report/my_reports_screen.dart';

class WasteApp extends StatelessWidget {
  const WasteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Reporting App',

      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),

      // Initial screen
      initialRoute: '/login',

      // Routes
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/add-report', page: () => const AddReportScreen()),
        GetPage(name: '/my-reports', page: () => MyReportsScreen()),
      ],
    );
  }
}
