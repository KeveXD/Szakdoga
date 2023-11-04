import 'package:buxa/pages/register_page.dart';
import 'package:buxa/pages/menu_page.dart';
import 'package:buxa/pages/debt_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    //adatkötés
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    //csak probabol kell teszteleshez konnyebb
    emailController.text = 'proba@gmail.com';
    passwordController.text = 'Proba123';

    Future<void> loginFirebase(BuildContext context) async {
      final email = emailController.text;
      final password = passwordController.text;

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
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
      } catch (e) {
        print('Hiba a bejelentkezés során: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Bejelentkezés'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/kezdo.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 75),
              Text(
                'Légy rendszerezett',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xFF465A61),
                  fontFamily: 'casual',
                ),
              ),
              Text(
                'BuXa',
                style: TextStyle(
                  fontSize: 48,
                  color: const Color(0xFFF15E53),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'casual',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'email',
                  filled: true,
                  fillColor: const Color(0xFFB9F3EC),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'password',
                  filled: true,
                  fillColor: const Color(0xFFB9F3EC),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Text(
                'Elfelejtette a jelszót?',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF3A2C2B),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  loginFirebase(context);
                },
                child: const Text('Bejelentkezés'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Regisztrációs oldalra navigáció.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  'Még nincs felhasználóm\nRegisztrálok',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color(0xFF4E3432),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const CircularProgressIndicator(
                // A láthatóság (visible vagy invisible) a szükséglet szerint változtatható.
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
