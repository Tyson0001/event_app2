import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProfilePage extends StatelessWidget {
  final User user;

  UserProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.red, // Set AppBar color to match the theme
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
          // User Profile Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${user.username}', style: TextStyle(fontSize: 16, color: Colors.black)),
                Text('Email: ${user.email}', style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 20),
                Text('Registered Events:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('Music Concert on 2024-11-15', style: TextStyle(color: Colors.black)),
                Text('Art Exhibition on 2024-12-01', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
