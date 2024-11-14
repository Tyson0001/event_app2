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

  EventDetailsPage({required this.event});

  DateTime? _parseDateTime(String date, String time) {
    try {
      final dateParts = date.split(' ');
      if (dateParts.length != 2) return null;

      final day = int.parse(dateParts[0]);
      final month = _getMonthNumber(dateParts[1]);
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(2024, month, day, hour, minute);
    } catch (e) {
      print("Error parsing date and time: $e");
      return null;
    }
  }

  int _getMonthNumber(String month) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
      'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
      'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    return months[month] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final eventDateTime = _parseDateTime(event['date'] ?? '1 Jan', event['time'] ?? '00:00');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(event['title'] ?? 'Event Details'),
        actions: [
          // Notification Button - Opens NotificationsPage without specific event data
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
          ),
          // Helpline Button
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
            height: 200.0,
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
