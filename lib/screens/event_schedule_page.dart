import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class EventSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Event Schedule'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Event Schedule',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          Expanded(child: TabBarSection()),
        ],
      ),
    );
  }
}

class TabBarSection extends StatelessWidget {
  // Function to load event data from the events.json file
  Future<Map<String, dynamic>> loadEventData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/events.json');
      return json.decode(jsonString);
    } catch (e) {
      print("Error loading JSON: $e");
      return {}; // Return an empty map in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: loadEventData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading events'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No events found'));
        } else {
          final eventData = snapshot.data!;
          final days = eventData.keys.toList(); // Get all the days from the data

          return DefaultTabController(
            length: days.length,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.red,
                  indicator: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isScrollable: true,
                  tabs: days.map((day) => Tab(text: day)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: days.map((day) {
                      final events = eventData[day] as List<dynamic>? ?? [];
                      return EventList(day: day, events: events);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class EventList extends StatelessWidget {
  final String day;
  final List<dynamic> events;

  EventList({required this.day, required this.events});

  DateTime? _parseDateTime(String day, String time) {
    try {
      final dateParts = day.split(' ');
      if (dateParts.length != 2) return null;

      final month = _getMonthNumber(dateParts[1]);
      final dayNumber = int.parse(dateParts[0]);

      final timeParts = time.split(' ');
      final timeString = timeParts[0];
      final hourMinute = timeString.split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);

      if (timeParts.length > 1) {
        final amPm = timeParts[1];
        if (amPm == 'PM' && hour != 12) hour += 12;
        if (amPm == 'AM' && hour == 12) hour = 0;
      }

      return DateTime(2024, month, dayNumber, hour, minute);
    } catch (e) {
      print("Error parsing date and time: $e");
      return null;
    }
  }

  int _getMonthNumber(String month) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return months[month] ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final eventDateTime = _parseDateTime(day, event['time'] ?? '00:00');
        final eventVenue = event['venue'] ?? 'No venue';

        return EventCard(
          title: event['title'] ?? 'No title',
          date: 'Date: $day',
          time: 'Time: ${event['time'] ?? 'No time'}',
          venue: 'Venue: $eventVenue',
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String venue;

  EventCard({
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.event, color: Colors.red),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            Text(time),
            Text(venue),
          ],
        ),
      ),
    );
  }
}
