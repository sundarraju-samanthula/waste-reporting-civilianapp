import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/add-report');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Error");
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/add-report');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registration Failed", e.message ?? "Error");
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
