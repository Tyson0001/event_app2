import 'package:flutter/material.dart';

class DirectoryPage extends StatelessWidget {
  final List<Map<String, String>> attendees = [
    {
      'name': 'Alice Johnson',
      'photo': 'assets/images/event1.jpg',
      'profession': 'Software Engineer at TechCorp'
    },
    {
      'name': 'Bob Smith',
      'photo': 'assets/images/event2.jpg',
      'profession': 'Project Manager at Innovate Inc.'
    },
    {
      'name': 'Carol Williams',
      'photo': 'assets/images/event3.jpg',
      'profession': 'Designer at Creative Studios'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendees Directory'),
      ),
      body: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (context, index) {
          final attendee = attendees[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(attendee['photo']!),
                radius: 30,
              ),
              title: Text(attendee['name']!),
              subtitle: Text(attendee['profession']!),
            ),
          );
        },
      ),
    );
  }
}
