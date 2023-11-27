import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buxa/view/login_page.dart';
import 'package:buxa/viewmodel/register_viewmodel.dart';

class RegisterPage extends StatelessWidget {
  final RegisterViewModel _viewModel = RegisterViewModel();

  RegisterPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                  //contentPadding: const EdgeInsets all(12),
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
                  _viewModel.registerWithEmailAndPassword(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                },
                child: const Text('Regisztráció'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
