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
            apiKey: "AIzaSyB17CUSJ77X1Xc-8Ph7Yoci9ivmC9IO5fE",
            projectId: "buxaflutter2",
            messagingSenderId: "875595350767",
            appId: "1:875595350767:web:6bc86c822c1625a209d11a"));
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
