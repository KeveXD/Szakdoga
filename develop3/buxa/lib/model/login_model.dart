import 'package:firebase_auth/firebase_auth.dart';

class LoginModel {
  //firebase authentikáció
  Future<User?> loginFirebase(String email, String password) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Hiba a bejelentkezés során: $e');
      return null;
    }
  }
}
