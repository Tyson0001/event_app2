





import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventSchedulePage extends StatelessWidget {
  final Map<String, String> event;

  EventSchedulePage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Event Schedule '),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Reload Event Data',
            onPressed: () async {
              // Fetch event data when reload icon is tapped
              await TabBarSection.fetchAndStoreEventData(context, event['eventCode']!);
            },
          ),
        ],
      ),
      body: Expanded(child: TabBarSection(event: event)),
    );
  }
}

class TabBarSection extends StatelessWidget {
  final Map<String, String> event;

  TabBarSection({required this.event});

  // Fetch event data from URL and store it locally
  static Future<void> fetchAndStoreEventData(BuildContext context, String eventCode) async {
    try {
      final url = 'https://gatherhub-r7yr.onrender.com/user/conference/$eventCode/eventCard/events';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final eventData = response.body;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('eventData', eventData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event data for $eventCode fetched successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch event data. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching event data: $e')),
      );
    }
  }

  // Load event data from local storage or assets
  Future<Map<String, dynamic>> loadEventData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('eventData');

      if (jsonString != null) {
        return json.decode(jsonString);
      } else {
        // Fallback to loading from assets if not found in local storage
        final assetData = await rootBundle.loadString('assets/events.json');
        return json.decode(assetData);
      }
    } catch (e) {
      print("Error loading event data: $e");
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
          final days = eventData.keys.toList();

          return DefaultTabController(
            length: days.length,
            child: Column(
              children: [
                SizedBox(height: 7.0),

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
                SizedBox(height: 1.0),
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

  DateTime _parseISODateTime(String isoDate) {
    return DateTime.parse(isoDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final eventDateTime = _parseISODateTime(event['time']);
        final eventVenue = event['venue'] ?? 'No venue';
        final formattedDate = "${eventDateTime.toLocal()}".split(' ')[0];
        final formattedTime = "${eventDateTime.toLocal()}".split(' ')[1].substring(0, 5);

        return EventCard(
          title: event['title'] ?? 'No title',
          date: 'Date: $formattedDate',
          time: 'Time: $formattedTime',
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
