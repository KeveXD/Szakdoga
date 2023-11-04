import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/view/login_page.dart';

// Register felület
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> _registerWithEmailAndPassword() async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Sikeres regisztráció
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        // Hibakezelés
        print("Hiba a regisztráció során: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Regisztráció'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                'Regisztráció',
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
              ElevatedButton(
                onPressed: () {
                  _registerWithEmailAndPassword();
                },
                child: const Text('Regisztráció'),
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
