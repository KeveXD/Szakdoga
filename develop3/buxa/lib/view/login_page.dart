import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/view/register_page.dart';
import 'package:buxa/view/menu_page.dart';
import 'package:buxa/viewmodel/login_viewmodel.dart'; // Az importált ViewModel

class LoginPage extends StatelessWidget {
  final LoginViewModel _viewModel = LoginViewModel(); // ViewModel példány

  LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    //adatkötés
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    //csak probabol kell teszteleshez konnyebb
    emailController.text = 'proba@gmail.com';
    passwordController.text = 'Proba123';

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
                    //borderSide: BorderSide none,
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
                  _viewModel.loginFirebase(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
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
