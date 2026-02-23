import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  Widget textField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool password = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: TextField(
            controller: controller,
            obscureText: password,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white70),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(.18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () {
        authController.login(emailCtrl.text.trim(), passCtrl.text.trim());
      },
      child: Container(
        height: 55,
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: const LinearGradient(
            colors: [Color(0xff5A67D8), Color(0xff7F9CF5)],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: const Center(
          child: Text(
            "LOGIN",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 39, 75, 207),
                  Color.fromARGB(255, 29, 163, 26),
                  Color.fromARGB(255, 12, 81, 9),
                ],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,

                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(22),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),

                        child: Container(
                          padding: const EdgeInsets.all(28),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            color: Colors.white.withOpacity(.15),

                            border: Border.all(
                              color: Colors.white.withOpacity(.25),
                            ),
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
                                  Icons.lock_outline,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 20),

                              //-------------------------------- TITLE
                              const Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                "Login to continue",
                                style: TextStyle(color: Colors.white70),
                              ),

                              const SizedBox(height: 30),

                              textField(
                                hint: "Email Address",
                                icon: Icons.email_outlined,
                                controller: emailCtrl,
                              ),

                              textField(
                                hint: "Password",
                                icon: Icons.lock_outline,
                                controller: passCtrl,
                                password: true,
                              ),

                              const SizedBox(height: 10),

                              loginButton(),

                              const SizedBox(height: 15),

                              TextButton(
                                onPressed: () => Get.toNamed('/register'),
                                child: const Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
