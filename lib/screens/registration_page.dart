// // Sure, here's the updated code with improved visibility for the text fields in both light and dark mode:


// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import 'user_profile_page.dart'; // Adjust import based on your project structure

// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void _register() {
//     if (_formKey.currentState!.validate()) {
//       // Create a User instance with the registration data
//       final user = User(
//         username: usernameController.text,
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Registration successful!')),
//       );

//       // Navigate to UserProfilePage with the user data
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => UserProfilePage(
//             username: user.username,
//             email: user.email,
//             profession: user.profession ?? 'Not provided', // Default if profession is null
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDarkMode ? Colors.white : Colors.black;
//     final fillColor = isDarkMode ? Colors.grey[900]! : Colors.grey[200];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//         backgroundColor: Colors.red,
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background Image
          
//           // Semi-transparent overlay for readability
//           Container(
//             color: Colors.white.withOpacity(0.5),
//           ),
//           // Registration form
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Username field
//                   TextFormField(
//                     controller: usernameController,
//                     decoration: InputDecoration(
//                       labelText: 'Username',
//                       labelStyle: TextStyle(color: textColor),
//                       fillColor: fillColor,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textColor.withOpacity(0.5)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textColor),
//                       ),
//                     ),
//                     validator: (value) => value!.isEmpty ? 'Enter a username' : null,
//                     style: TextStyle(color: textColor),
//                   ),
//                   SizedBox(height: 16),
//                   // Email field
//                   TextFormField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: TextStyle(color: textColor),
//                       fillColor: fillColor,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textColor.withOpacity(0.5)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textColor),
//                       ),
//                     ),
//                     validator: (value) => value!.isEmpty ? 'Enter an email' : null,
//                     style: TextStyle(color: textColor),
//                   ),
//                   SizedBox(height: 16),
//                   // Password field
//                   TextFormField(
//                     controller: passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: TextStyle(color: textColor),
//                       fillColor: fillColor,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textColor.withOpacity(0.5)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: textColor),
//                       ),
//                     ),
//                     obscureText: true,
//                     validator: (value) => value!.isEmpty ? 'Enter a password' : null,
//                     style: TextStyle(color: textColor),
//                   ),
//                   SizedBox(height: 20),
//                   // Register button
//                   ElevatedButton(
//                     onPressed: _register,
//                     child: Text('Register'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       minimumSize: Size(double.infinity, 36),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }













































import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLinkedInRegistration = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controllers for full registration
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  // Controller for LinkedIn registration
  final TextEditingController linkedInController = TextEditingController();

  Future<void> _clearPreviousData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear all existing registration data
    await prefs.remove('linkedInUrl');
    await prefs.remove('name');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('about');
    await prefs.remove('isLinkedInUser');
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear all previous data before saving new registration
      await _clearPreviousData();

      if (isLinkedInRegistration) {
        // Save LinkedIn URL and name only
        await prefs.setString('linkedInUrl', linkedInController.text);
        await prefs.setString('name', nameController.text);
        await prefs.setString('username', usernameController.text);
        await prefs.setBool('isLinkedInUser', true);
      } else {
        // Save full registration data
        await prefs.setString('name', nameController.text);
        await prefs.setString('username', usernameController.text);
        await prefs.setString('email', emailController.text);
        await prefs.setString('about', aboutController.text);
        await prefs.setBool('isLinkedInUser', false);
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Registration successful!')),
      // );

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserProfilePage(),
      //   ),
      // );

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        // Check if username exists
        final usernameCheckResponse = await http.post(
          Uri.parse('https://gatherhub-r7yr.onrender.com/user/checkUsername'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': usernameController.text,
          }),
        );

        // Handle username check response
        if (usernameCheckResponse.statusCode == 401) {
          Navigator.of(context, rootNavigator: true)
              .pop(); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Username already exists.',
              ),
            ),
          );
          return; // Stop further execution
        }

        // if (usernameCheckResponse.statusCode == 401) {
        //   Navigator.of(context, rootNavigator: true)
        //       .pop(); // Dismiss loading dialog
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(
        //         'Username already exists. Status code: ${usernameCheckResponse.statusCode}. '
        //         'Response: ${usernameCheckResponse.body}',
        //       ),
        //     ),
        //   );
        //   return; // Stop further execution
        // }



        final emailCheckResponse = await http.post(
          Uri.parse('https://gatherhub-r7yr.onrender.com/user/checkEmail'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': usernameController.text,
          }),
        );
        
        if (emailCheckResponse.statusCode == 401) {
          Navigator.of(context, rootNavigator: true)
              .pop(); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email already exists. '
              ),
            ),
          );
          return; // Stop further execution
        }

        // if (emailCheckResponse.statusCode == 401) {
        //   Navigator.of(context, rootNavigator: true)
        //       .pop(); // Dismiss loading dialog
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(
        //         'email already exists. Status code: ${emailCheckResponse.statusCode}. '
        //         'Response: ${emailCheckResponse.body}',
        //       ),
        //     ),
        //   );
        //   return; // Stop further execution
        // }


        // else if (usernameCheckResponse.statusCode != 401) {
        //   // throw Exception('Failed to validate username');
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(
        //         'Username is available. Status code: ${usernameCheckResponse.statusCode}. '
        //         'Response: ${usernameCheckResponse.body}',
        //       ),
        //     ),
        //   );
        // }

        // Proceed to create account
        final response = await http.post(
          Uri.parse('https://gatherhub-r7yr.onrender.com/user/createAccount'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': nameController.text,
            // 'email': emailController.text ,
            'email': emailController.text.isEmpty ? usernameController.text : emailController.text,
            'username': usernameController.text,
            'password': passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to create account: ${response.body}')),
          );
        }
      } catch (e) {
        // Handle all errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        // Ensure loading dialog is dismissed
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Clear any existing data when the registration page is opened
    _clearPreviousData();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final fillColor = isDarkMode ? Colors.grey[900]! : Colors.grey[200]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
          // Registration form
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Registration type switch
                  Card(
                    color: fillColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Register with LinkedIn',
                            style: TextStyle(color: textColor),
                          ),
                          Switch(
                            value: isLinkedInRegistration,
                            onChanged: (value) {
                              setState(() {
                                isLinkedInRegistration = value;
                              });
                            },
                            activeColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  if (isLinkedInRegistration)
                    // LinkedIn URL field
                    Column(children: [
                      TextFormField(
                        controller: linkedInController,
                        decoration: InputDecoration(
                          labelText: 'LinkedIn Profile URL',
                          labelStyle: TextStyle(color: textColor),
                          fillColor: fillColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          prefixIcon: Icon(Icons.link, color: Colors.red),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your LinkedIn URL';
                          }
                          if (!value.startsWith('https://www.linkedin.com/')) {
                            return 'Enter a valid LinkedIn URL';
                          }
                          return null;
                        },
                        style: TextStyle(color: textColor),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: textColor),
                          fillColor: fillColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          prefixIcon: Icon(Icons.person, color: Colors.red),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your full name' : null,
                        style: TextStyle(color: textColor),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: textColor),
                          fillColor: fillColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          prefixIcon:
                              Icon(Icons.alternate_email, color: Colors.red),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a username' : null,
                        style: TextStyle(color: textColor),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: textColor),
                          fillColor: fillColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.red),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        style: TextStyle(color: textColor),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: textColor),
                          fillColor: fillColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: textColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.red),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        style: TextStyle(color: textColor),
                      ),
                    ])
                  else
                    // Full registration fields
                    Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: textColor),
                            fillColor: fillColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: textColor.withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.red),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter your full name' : null,
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: textColor),
                            fillColor: fillColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: textColor.withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                            ),
                            prefixIcon:
                                Icon(Icons.alternate_email, color: Colors.red),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter a username' : null,
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: textColor),
                            fillColor: fillColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: textColor.withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.red),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter an email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: textColor),
                            fillColor: fillColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: textColor.withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.red),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: textColor),
                            fillColor: fillColor,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: textColor.withOpacity(0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.red),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                  SizedBox(height: 24),
                  // Register button
                  ElevatedButton(
                    onPressed: _register,
                    child: Text(isLinkedInRegistration
                        ? 'Register with LinkedIn'
                        : 'Complete Registration'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
