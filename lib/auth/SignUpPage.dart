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

  String _firstNameError = '';
  String _lastNameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

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
      body: SingleChildScrollView(
        child: Center(
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
                // Error message for first name
                if (_firstNameError.isNotEmpty)
                  Text(
                    _firstNameError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Last name:",
                        style: TextStyle(fontSize: 15, color: Colors.purple)),
                  ),
                  controller: _lastName,
                ),
                // Error message for last name
                if (_lastNameError.isNotEmpty)
                  Text(
                    _lastNameError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Email:",
                        style: TextStyle(fontSize: 15, color: Colors.purple)),
                  ),
                  controller: _email,
                ),
                // Error message for email
                if (_emailError.isNotEmpty)
                  Text(
                    _emailError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
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
                // Error message for password
                if (_passwordError.isNotEmpty)
                  Text(
                    _passwordError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
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

                if (_confirmPasswordError.isNotEmpty)
                  Text(
                    _confirmPasswordError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
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
                ),
              ],
            ),
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

  void _clearErrors() {
    setState(() {
      _firstNameError = '';
      _lastNameError = '';
      _emailError = '';
      _passwordError = '';
      _confirmPasswordError = '';
    });
  }

  bool _validateInputs() {
    _clearErrors(); // Clear previous errors

    if (_firstName.text.isEmpty) {
      _firstNameError = 'Please enter your first name.';
    } else if (!_isAlphabetic(_firstName.text)) {
      _firstNameError = 'First name should only contain letters.';
    }

    if (_lastName.text.isEmpty) {
      _lastNameError = 'Please enter your last name.';
    } else if (!_isAlphabetic(_lastName.text)) {
      _lastNameError = 'Last name should only contain letters.';
    }

    if (_email.text.isEmpty) {
      _emailError = 'Please enter your email.';
    }

    if (_password.text.isEmpty) {
      _passwordError = 'Please enter your password.';
    } else if (_password.text.length < 6) {
      _passwordError = 'Password should be at least 6 characters long.';
    }

    if (_confirmPassword.text.isEmpty) {
      _confirmPasswordError = 'Please confirm your password.';
    } else if (_password.text != _confirmPassword.text) {
      _confirmPasswordError = 'Passwords do not match.';
    }

    // Check if there are any errors
    return _firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _emailError.isEmpty &&
        _passwordError.isEmpty &&
        _confirmPasswordError.isEmpty;
  }

  bool _isAlphabetic(String input) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(input);
  }

  _signup() async {
    if (!_validateInputs()) {
      setState(() {}); // Refresh the UI to show error messages
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

  void _showError(String message) {
    // Handle general errors, if needed
  }
}
