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
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (context, index) {
          final attendee = attendees[index];
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
                              attendee['photo']!,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                attendee['name']!,
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
                  backgroundImage: AssetImage(attendee['photo']!),
                  radius: 30,
                ),
              ),
              title: Text(
                attendee['name']!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                attendee['profession']!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
