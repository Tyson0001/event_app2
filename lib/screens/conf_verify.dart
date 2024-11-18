// password_verification_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordVerificationPage extends StatefulWidget {
  final Map<String, String> eventDetails;

  const PasswordVerificationPage({Key? key, required this.eventDetails}) : super(key: key);

  @override
  _PasswordVerificationPageState createState() => _PasswordVerificationPageState();
}

class _PasswordVerificationPageState extends State<PasswordVerificationPage> {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _errorMessage = '';
  String _successMessage = '';
  bool _isLoading = false;

  Future<void> _verifyPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://gatherhub-r7yr.onrender.com/user/conference/checkConferenceCodeAndPassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'conferenceCode': widget.eventDetails['conferenceCode'],
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Show success message and navigate after a short delay
        setState(() {
          _successMessage = 'Password verified successfully!';
          _isLoading = false;
        });

        // Wait for a brief moment to show the success message
        await Future.delayed(Duration(milliseconds: 500));

        // Check if the widget is still mounted before navigating
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/eventDetails',
            arguments: widget.eventDetails,
          );
        }
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ?? 'Incorrect password. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error verifying password: $e');
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Password'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Enter Event Password',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Event Code: ${widget.eventDetails['conferenceCode']}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      onSubmitted: (_) => _verifyPassword(),
                      // Auto-focus the text field when the page opens
                      autofocus: true,
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (_successMessage.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        _successMessage,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 0),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Verify Password'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}