// Sure, here's the updated code with improved visibility for the text fields in both light and dark mode:


import 'package:flutter/material.dart';
import '../models/user.dart';
import 'user_profile_page.dart'; // Adjust import based on your project structure

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Create a User instance with the registration data
      final user = User(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to UserProfilePage with the user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(
            username: user.username,
            email: user.email,
            profession: user.profession ?? 'Not provided', // Default if profession is null
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final fillColor = isDarkMode ? Colors.grey[900]! : Colors.grey[200];

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          
          // Semi-transparent overlay for readability
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
          // Registration form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Username field
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: textColor),
                      fillColor: fillColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter a username' : null,
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 16),
                  // Email field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: textColor),
                      fillColor: fillColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 16),
                  // Password field
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: textColor),
                      fillColor: fillColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Enter a password' : null,
                    style: TextStyle(color: textColor),
                  ),
                  SizedBox(height: 20),
                  // Register button
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

