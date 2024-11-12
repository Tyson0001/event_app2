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
          Expanded(child: TabBarSection()), // Wrap TabBarSection in Expanded
        ],
      ),
    );
  }
}

class TabBarSection extends StatelessWidget {
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
          return DefaultTabController(
            length: 4,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.red,
                  indicator: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tabs: [
                    Tab(text: '28th Sept'),
                    Tab(text: '29th Sept'),
                    Tab(text: '30th Sept'),
                    Tab(text: '1st Oct'),
                  ],
                ),
                Expanded( // Wrap TabBarView in Expanded to give it constraints
                  child: TabBarView(
                    children: [
                      EventList(day: '28th Sept', events: eventData['28th Sept'] ?? []),
                      EventList(day: '29th Sept', events: eventData['29th Sept'] ?? []),
                      EventList(day: '30th Sept', events: eventData['30th Sept'] ?? []),
                      EventList(day: '1st Oct', events: eventData['1st Oct'] ?? []),
                    ],
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          title: event['title'] ?? 'No title',
          date: 'Date: $day',
          time: 'Time: ${event['time'] ?? 'No time'}',
          venue: 'Venue: ${event['venue'] ?? 'No venue'}',
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

  EventCard({required this.title, required this.date, required this.time, required this.venue});

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
