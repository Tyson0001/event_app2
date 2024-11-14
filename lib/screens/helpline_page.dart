import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplinePage extends StatelessWidget {
  final List<Map<String, String>> helplines = [
    {
      'name': 'Event Support',
      'phone': '+1234567890',
    },
    {
      'name': 'Tech Assistance',
      'phone': '+0987654321',
    },
    {
      'name': 'Emergency Contact',
      'phone': '+1122334455',
    },
  ];

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
        // Successfully launched phone dialer
      } else {
        _showErrorMessage(context, 'Could not launch $phoneNumber');
      }
    } catch (e) {
      _showErrorMessage(context, 'Error: $e');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helpline'),
      ),
      body: ListView.builder(
        itemCount: helplines.length,
        itemBuilder: (context, index) {
          final helpline = helplines[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(helpline['name']!),
              subtitle: Text(helpline['phone']!),
              trailing: IconButton(
                icon: Icon(Icons.phone),
                onPressed: () => _makePhoneCall(helpline['phone']!, context),
              ),
            ),
          );
        },
      ),
    );
  }
}
