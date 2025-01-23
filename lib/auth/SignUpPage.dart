import 'dart:developer';

import 'package:demo_flutter/auth/LoginPage.dart';
import 'package:demo_flutter/auth/auth_service.dart';
import 'package:demo_flutter/main.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = AuthService();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SignUp",
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat"),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(23),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Create your account",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 23),
              TextField(
                decoration: InputDecoration(
                  label: Text("First name:",
                      style: TextStyle(fontSize: 15, color: Colors.purple)),
                ),
                controller: _firstName,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Last name:",
                      style: TextStyle(fontSize: 15, color: Colors.purple)),
                ),
                controller: _lastName,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  label: Text("Email:",
                      style: TextStyle(fontSize: 15, color: Colors.purple)),
                ),
                controller: _email,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  label: Text("Password:",
                      style: TextStyle(fontSize: 15, color: Colors.purple)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPassword,
                decoration: InputDecoration(
                  label: Text("Confirm password:",
                      style: TextStyle(fontSize: 15, color: Colors.purple)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  "Already have an account? login",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  goToHomePage(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validateInputs() {
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      _showError('Please fill in all fields.');
      return false;
    }

    if (!_isAlphabetic(_firstName.text) || !_isAlphabetic(_lastName.text)) {
      _showError('First and Last names should only contain letters.');
      return false;
    }

    if (_password.text != _confirmPassword.text) {
      _showError('Passwords do not match.');
      return false;
    }

    if (_password.text.length < 6) {
      _showError('Password should be at least 6 characters long.');
      return false;
    }

    return true;
  }

  bool _isAlphabetic(String input) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(input);
  }

  _signup() async {
    if (!_validateInputs()) {
      return; // Stop execution if validation fails
    }

    try {
      final user = await _auth.createUserWithEmailAndPassword(
        _email.text,
        _password.text,
      );
      if (user != null) {
        log("User registered successfully");
        goToHomePage(context);
      }
    } catch (e) {
      log("Error during registration: $e");
      _showError("Registration failed: $e");
    }
  }
}
