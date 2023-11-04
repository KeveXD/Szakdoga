import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/view/login_page.dart';
import 'package:buxa/widgets/error_dialog.dart';
import 'package:buxa/model/register_model.dart';

class RegisterViewModel {
  final RegisterModel _model = RegisterModel();

  Future<void> registerWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    final user = await _model.registerWithEmailAndPassword(email, password);

    if (user != null) {
      // Sikeres regisztráció esetén továbbnavigáljuk a LoginPage-re.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Sikertelen regisztráció
      ErrorDialog.show(
          context, 'Hiba a regisztráció során. Kérjük, próbálja újra.');
    }
  }
}
