// import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void _login() {
//     if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
//       Navigator.pushReplacementNamed(context, '/home');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter email and password')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//         backgroundColor: Colors.red, // AppBar color to match red theme
//       ),
//       body: Container(
//         color: Colors.white.withOpacity(0.5), // Semi-transparent background
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(
//                       color: Colors.black87, // Set label color for readability
//                     ),
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   style: TextStyle(color: Colors.black), // Consistent text color for visibility
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: TextStyle(
//                       color: Colors.black87, // Set label color for readability
//                     ),
//                     border: OutlineInputBorder(),
//                     filled: true,
//                     fillColor: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
//                   ),
//                   obscureText: true,
//                   style: TextStyle(color: Colors.black), // Consistent text color for visibility
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _login,
//                   child: Text('Login'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red, // Set button color to red
//                     minimumSize: Size(double.infinity, 36),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/register');
//                   },
//                   child: Text(
//                     'Create an account',
//                     style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold), // Set text color to red
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
































































import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Track password visibility
  bool _isLoading = false; // Track loading state

  void _login() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final response = await http.post(
      Uri.parse('https://gatherhub-r7yr.onrender.com/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false; // Stop loading
    });

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.white.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                  ),
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible, // Toggle obscure text
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator() // Show loading spinner while logging in
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity, 36),
                        ),
                      ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}