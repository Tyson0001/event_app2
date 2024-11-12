import 'package:flutter/material.dart';

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
      // Handle registration logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.red, // Optional: Change AppBar color
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/backgroundimage2.jpg', // Path to your background image
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Image not available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          // Semi-transparent overlay for readability
          Container(
            color: Colors.white.withOpacity(0.5), // Dark overlay for better text visibility
          ),
          // Registration form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      fillColor: isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.1),
                      filled: true,
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter a username' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.1),
                      filled: true,
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.1),
                      filled: true,
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Enter a password' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Optional: Change button color
                      minimumSize: Size(double.infinity, 36), // Full-width button
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
