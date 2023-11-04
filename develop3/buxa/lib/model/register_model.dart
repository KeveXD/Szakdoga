import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/view/login_page.dart';
import 'package:buxa/widgets/error_dialog.dart';

class RegisterModel {
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print("Hiba a regisztráció során: $e");
      return null;
    }
  }
}
