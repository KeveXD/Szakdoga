import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Hozzáadva a BuildContext és a Navigator importálásához
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/model/login_model.dart';
import 'package:buxa/view/menu_page.dart';
import 'package:buxa/widgets/error_dialog.dart';

class LoginViewModel {
  final LoginModel _model = LoginModel();

  String? getUserEmail() {
    return _model.getUserEmail();
  }

  Future<void> loginFirebase(
      String email, String password, BuildContext context) async {
    final user = await _model.loginFirebase(email, password);

    if (user != null) {
      clearAllRepositoryData();
      // Sikeres bejelentkezés esetén továbbnavigáljuk a MenuPage-re.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MenuPage()));
    } else {
      // Sikertelen bejelentkezés

      ErrorDialog.show(context, 'Hibás email vagy jelszó.');
    }
  }

  Future<void> clearAllRepositoryData() async {
    if (!kIsWeb) await _model.clearAllRepositoryData();
  }
}
