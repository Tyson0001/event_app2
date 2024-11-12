import 'package:flutter/material.dart';

class MentorPage extends StatelessWidget {
  final List<Map<String, String>> mentors = [
    {
      'name': 'Dr. Emily Brown',
      'photo': 'assets/images/event1.jpg',
      'profession': 'Senior AI Researcher at DataLabs'
    },
    {
      'name': 'Mr. James Wilson',
      'photo': 'assets/images/event2.jpg',
      'profession': 'Tech Lead at FutureTech'
    },
    {
      'name': 'Ms. Sarah Lee',
      'photo': 'assets/images/event3.jpg',
      'profession': 'UX Strategist at DesignWorks'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentors'),
      ),
      body: ListView.builder(
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(mentor['photo']!),
                radius: 30,
              ),
              title: Text(mentor['name']!),
              subtitle: Text(mentor['profession']!),
            ),
          );
        },
      ),
    );
  }
}
