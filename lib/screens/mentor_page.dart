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
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              mentor['photo']!,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                mentor['name']!,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(mentor['photo']!),
                  radius: 30,
                ),
              ),
              title: Text(
                mentor['name']!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                mentor['profession']!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
