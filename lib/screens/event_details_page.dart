import 'package:flutter/material.dart';
import 'event_schedule_page.dart';
import 'detail_page.dart';
import 'directory_page.dart';
import 'sponsors_page.dart';
import 'mentor_page.dart';
import 'helpline_page.dart';
import 'notifications_page.dart';
import 'food_counter_page.dart';

class EventDetailsPage extends StatelessWidget {
  final Map<String, String> event;

  // Constructor to accept the event parameter
  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(event['title'] ?? 'Event Details'), // Display event title if available
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.contact_phone),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelplinePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Image carousel
          Container(
            height: 200.0, // Adjust height as needed
            child: PageView(
              children: [
                Image.asset('assets/images/event1.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/event2.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/event3.jpg', fit: BoxFit.cover),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              padding: EdgeInsets.all(8.0),
              children: [
                _buildGridButton(
                  context,
                  label: 'Sponsors',
                  icon: Icons.attach_money,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SponsorsPage()),
                    );
                  },
                ),
                _buildGridButton(
                  context,
                  label: 'Directory',
                  icon: Icons.book,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DirectoryPage()),
                    );
                  },
                ),
                _buildGridButton(
                  context,
                  label: 'Event Schedule',
                  icon: Icons.schedule,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventSchedulePage()),
                    );
                  },
                ),
                _buildGridButton(
                  context,
                  label: 'Details',
                  icon: Icons.info,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage()),
                    );
                  },
                ),
                _buildGridButton(
                  context,
                  label: 'Mentor',
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MentorPage()),
                    );
                  },
                ),
                _buildGridButton(
                  context,
                  label: 'Food Counter',
                  icon: Icons.fastfood,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FoodCounterPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required VoidCallback onPressed,
      }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(8.0),
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(label, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
