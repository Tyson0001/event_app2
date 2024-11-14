import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String currentDate = '';
  String currentTime = '';
  List<Map<String, dynamic>> upcomingEvents = [];
  List<Map<String, dynamic>> allEventsOfTheDay = [];
  int eventCount = 0;

  @override
  void initState() {
    super.initState();
    updateCurrentDateTime();
    loadEventData();
  }

  void updateCurrentDateTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat('d MMM');
    currentDate = dateFormat.format(now);

    final timeFormat = DateFormat('h:mm a');
    currentTime = timeFormat.format(now);
  }

  Future<void> loadEventData() async {
    final String response = await rootBundle.loadString('assets/events.json');
    final Map<String, dynamic> data = json.decode(response);

    debugPrint('Loaded data from events.json');

    final now = DateTime.now();
    List<Map<String, dynamic>> eventsToNotify = [];
    List<Map<String, dynamic>> eventsToday = [];

    if (data.containsKey(currentDate)) {
      final events = data[currentDate];
      eventCount = events.length;
      for (var event in events) {
        DateTime eventTime = DateFormat('h:mm a').parse(event['time']);
        final eventDateTime = DateTime(
            now.year, now.month, now.day, eventTime.hour, eventTime.minute);
        final timeDifference = eventDateTime.difference(now).inMinutes;

        if (timeDifference > 0) {
          eventsToday.add({
            'title': event['title'],
            'venue': event['venue'],
            'time': event['time'],
          });
        }

        if (timeDifference <= 30 && timeDifference > 0) {
          eventsToNotify.add({
            'title': event['title'],
            'venue': event['venue'],
            'timeDifference': timeDifference,
          });
          _showEventNotification(event['title'], event['venue']);
        }
      }

      setState(() {
        allEventsOfTheDay = eventsToday;
        upcomingEvents = eventsToNotify;
      });
    }
  }

  void _showEventNotification(String eventTitle, String eventVenue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hurry Up!"),
          content: Text(
            "$eventTitle is about to start at $eventVenue.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Notifications")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "Current Date: $currentDate",
            //   style: TextStyle(fontSize: 24),
            // ),
            // SizedBox(height: 10),
            // Text(
            //   "Current Time: $currentTime",
            //   style: TextStyle(fontSize: 24),
            // ),
            // SizedBox(height: 10),
            // Text(
            //   "Events on this day: $eventCount",
            //   style: TextStyle(fontSize: 18),
            // ),
            // SizedBox(height: 20),
            Text(
              "All Events Today",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...allEventsOfTheDay.map((event) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "${event['title']} at ${event['venue']} - ${event['time']}",
                    style: TextStyle(fontSize: 18),
                  ),
                  tileColor: Colors.lightBlue[50],
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              "Upcoming Events (Next 30 Minutes)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...upcomingEvents.map((event) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "Hurry up! ${event['title']} is going to start at ${event['venue']} in ${event['timeDifference']} minutes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  tileColor: Colors.orange[100],
                ),
              );
            }).toList(),
            if (upcomingEvents.isEmpty)
              Text(
                "No events starting in the next 30 minutes",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:intl/intl.dart';

// class NotificationsPage extends StatefulWidget {
//   @override
//   _NotificationsPageState createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   List<Map<String, dynamic>> upcomingEvents = [];

//   @override
//   void initState() {
//     super.initState();
//     loadEventData();
//   }

//   Future<void> loadEventData() async {
//     final String response = await rootBundle.loadString('assets/events.json');
//     final Map<String, dynamic> data = json.decode(response);

//     final now = DateTime.now();
//     List<Map<String, dynamic>> eventsToNotify = [];

//     final dateFormat = DateFormat('d MMM');
//     String currentDate = dateFormat.format(now);

//     if (data.containsKey(currentDate)) {
//       final events = data[currentDate];
//       for (var event in events) {
//         DateTime eventTime = DateFormat('h:mm a').parse(event['time']);
//         final eventDateTime = DateTime(now.year, now.month, now.day, eventTime.hour, eventTime.minute);
//         final timeDifference = eventDateTime.difference(now).inMinutes;

//         if (timeDifference <= 30 && timeDifference > 0) {
//           eventsToNotify.add({
//             'title': event['title'],
//             'venue': event['venue'],
//             'timeDifference': timeDifference,
//           });
//           _showEventNotification(event['title'], event['venue']);
//         }
//       }

//       setState(() {
//         upcomingEvents = eventsToNotify;
//       });
//     }
//   }

//   void _showEventNotification(String eventTitle, String eventVenue) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Hurry Up!"),
//           content: Text(
//             "$eventTitle is about to start at $eventVenue in 30 minutes.",
//             style: TextStyle(fontSize: 18),
//           ),
//           actions: [
//             TextButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Event Notifications")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (upcomingEvents.isEmpty)
//               Text(
//                 "No events starting in the next 30 minutes",
//                 style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//               ),
//             ...upcomingEvents.map((event) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   title: Text(
//                     "Hurry up! ${event['title']} is going to start at ${event['venue']} in ${event['timeDifference']} minutes",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   tileColor: Colors.orange[100],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
