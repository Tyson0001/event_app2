import 'package:flutter/material.dart';
import 'dart:async';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationsPage> {
  // Event data simulation
  final String eventVenue = "Main Hall, Expo Center";
  final DateTime eventStartTime = DateTime.now().add(Duration(minutes: 1)); // Set to 5 minutes from now

  // Stream controller to simulate real-time updates
  late Stream<DateTime> eventTimeStream;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Create a stream that emits the current time every second
    eventTimeStream = Stream<DateTime>.periodic(Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Notifications'),
      ),
      body: Center(
        child: StreamBuilder<DateTime>(
          stream: eventTimeStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final currentTime = snapshot.data!;
              final timeLeft = eventStartTime.difference(currentTime);

              if (timeLeft.isNegative) {
                return Text(
                  "The event has started!",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upcoming Event',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Venue: $eventVenue',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Time Remaining: ${timeLeft.inMinutes} minutes and ${timeLeft.inSeconds % 60} seconds',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ],
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
