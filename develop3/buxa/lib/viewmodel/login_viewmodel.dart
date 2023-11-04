import 'package:flutter/material.dart'; // Hozzáadva a BuildContext és a Navigator importálásához
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/model/login_model.dart';
import 'package:buxa/view/menu_page.dart';

class LoginViewModel {
  final LoginModel _model = LoginModel();

  Future<void> loginFirebase(
      String email, String password, BuildContext context) async {
    final user = await _model.loginFirebase(email, password);

    if (user != null) {
      // Sikeres bejelentkezés esetén továbbnavigáljuk a MenuPage-re.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MenuPage()));
    } else {
      // Sikertelen bejelentkezés
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hiba'),
            content: Text('Hibás email vagy jelszó.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
