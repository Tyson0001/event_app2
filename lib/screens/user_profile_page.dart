import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class UserProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String profession;

  const UserProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.profession,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/scan"); // Navigate to scan page
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.username.toUpperCase(),
              style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              widget.profession,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            PrettyQr(
              data:
                'Username: ${widget.username}\nEmail: ${widget.email}\nProfession: ${widget.profession}',
              size: 200,
              roundEdges: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} 






