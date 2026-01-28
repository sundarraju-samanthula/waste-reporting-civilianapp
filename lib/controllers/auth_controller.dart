import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login user with email & password
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to Home screen
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Register new user
  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to Home screen
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Registration Failed",
        e.message ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  /// Get current user (helper)
  User? get currentUser => _auth.currentUser;
}
