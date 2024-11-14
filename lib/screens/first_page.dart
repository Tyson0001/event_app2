import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'qr_scanner.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    _checkUserChoice(); // Check saved choice on init
  }

  // Check if a choice was previously made
  Future<void> _checkUserChoice() async {
    final prefs = await SharedPreferences.getInstance();
    final choice = prefs.getString('userChoice');

    if (choice == 'Attendees') {
      _navigateToPage(LoginPage());
    } else if (choice == 'Organizers' || choice == 'Catering Vendor') {
      _navigateToPage(QRScanner());
    }
  }

  // Navigate to selected page
  void _navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Role'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToPage(LoginPage()),
              child: const Text('Attendees'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPage(QRScanner()),
              child: const Text('Organizers'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPage(QRScanner()),
              child: const Text('Catering Vendor'),
            ),
          ],
        ),
      ),
    );
  }
}
