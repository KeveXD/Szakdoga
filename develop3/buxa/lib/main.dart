import 'package:buxa/view/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:buxa/database/debt_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //adatbazis inicializalasa
  //final dbHelper = DatabaseHelper();
  //await dbHelper.initializeDatabase();

  //webhez kel
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBB-DTWNja2Os08mO3DsWEMFetfYF9-ggY",
            projectId: "buxaflutter-58aca",
            messagingSenderId: "721978480828",
            appId: "1:721978480828:web:8e42aa67c15afa076658b9"));
  }
  //androidhoz is kell egy hasonló
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class Login extends StatelessWidget {
  const Login({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login screen',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 239, 238, 222),
      ),
      home: LoginPage(),
    );
  }
}
