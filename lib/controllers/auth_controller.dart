import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;

  /// ---------------- LOGIN ----------------
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _authService.login(email: email, password: password);

      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      String msg = "Login failed";

      if (e.code == 'user-not-found') {
        msg = "No account found for this email";
      } else if (e.code == 'wrong-password') {
        msg = "Incorrect password";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email address";
      }

      Get.snackbar("Login Failed", msg, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- REGISTER ----------------
  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;

      await _authService.register(email: email, password: password);

      final user = _authService.currentUser;
      if (user == null) throw Exception("User creation failed");

      /// ✅ CREATE FIRESTORE USER DOCUMENT (AUTOMATIC)
      await _db.collection('users').doc(user.uid).set({
        'email': email,
        'role': 'user', // default role
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      String msg = "Registration failed";

      if (e.code == 'email-already-in-use') {
        msg = "Email already registered";
      } else if (e.code == 'weak-password') {
        msg = "Password must be at least 6 characters";
      } else if (e.code == 'invalid-email') {
        msg = "Invalid email address";
      }

      Get.snackbar(
        "Registration Failed",
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }

  /// ---------------- CURRENT USER ----------------
  User? get currentUser => _authService.currentUser;
}
