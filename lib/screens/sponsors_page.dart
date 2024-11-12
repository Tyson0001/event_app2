import 'package:flutter/material.dart';

class SponsorsPage extends StatelessWidget {
  final List<Map<String, String>> sponsors = [
    {
      'name': 'TechCorp',
      'logo': 'assets/images/event1.jpg',
    },
    {
      'name': 'Innovate Inc.',
      'logo': 'assets/images/event2.jpg',
    },
    {
      'name': 'Creative Studios',
      'logo': 'assets/images/event3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sponsors'),
      ),
      body: ListView.builder(
        itemCount: sponsors.length,
        itemBuilder: (context, index) {
          final sponsor = sponsors[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.asset(
                sponsor['logo']!,
                width: 50,
                height: 50,
              ),
              title: Text(sponsor['name']!),
            ),
          );
        },
      ),
    );
  }
}
