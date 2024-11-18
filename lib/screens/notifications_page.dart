import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  final Function(int)? onNotificationUpdate;

  NotificationsPage({this.onNotificationUpdate});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int totalNotifications = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    calculateTotalNotifications();
  }

  Future<void> calculateTotalNotifications() async {
    int eventNotifications = await getEventNotificationsCount();
    int foodNotifications = await getFoodNotificationsCount();
    setState(() {
      totalNotifications = eventNotifications + foodNotifications;
    });
    if (widget.onNotificationUpdate != null) {
      widget.onNotificationUpdate!(totalNotifications);
    }
  }

  Future<List<dynamic>> loadFoodData() async {
    final prefs = await SharedPreferences.getInstance();

    // Try loading data from local storage
    final String? storedData = prefs.getString('foodData');

    if (storedData != null) {
      // Parse and return data from local storage
      return json.decode(storedData);
    }

    // If no data in local storage, load default data from assets
    final String response = await rootBundle.loadString('assets/food.json');
    return json.decode(response);
  }

  Future<Map<String, dynamic>> loadEventData() async {
  final prefs = await SharedPreferences.getInstance();

  // Attempt to load event data from local storage
  final String? storedData = prefs.getString('eventData');

  if (storedData != null) {
    // Parse and return the locally stored data
    return json.decode(storedData);
  }

  // If no data in local storage, load from the default JSON file in assets
  final String response = await rootBundle.loadString('assets/events.json');
  return json.decode(response);
}

  Future<int> getEventNotificationsCount() async {
    // final prefs = await SharedPreferences.getInstance();
    // final String? storedData = prefs.getString('foodData');
    final Map<String, dynamic> data = await loadEventData();
    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);

    int eventCount = 0;

    if (data.containsKey(todayKey)) {
      for (var event in data[todayKey]) {
        DateTime eventDateTime = DateTime.parse(event['time']);
        final timeDifference = eventDateTime.difference(now).inMinutes;

        if (timeDifference > 0 && timeDifference <= 30) {
          eventCount++;
        }
      }
    }
    return eventCount;
  }

  Future<int> getFoodNotificationsCount() async {
    // final prefs = await SharedPreferences.getInstance();
    // final String? storedData = prefs.getString('foodData');

    // final String response = await rootBundle.loadString('assets/food.json');
    // final List<dynamic> data = json.decode(response);

    final List<dynamic> data = await loadFoodData();
    final now = DateTime.now();

    int foodCount = 0;

    for (var foodItem in data) {
      DateTime foodStartTime = DateTime.parse(foodItem['startTime']);
      DateTime foodEndTime = DateTime.parse(foodItem['expiryTime']);

      final timeUntilStart = foodStartTime.difference(now).inMinutes;
      final timeUntilEnd = foodEndTime.difference(now).inMinutes;

      if ((timeUntilStart > 0 && timeUntilStart <= 15) ||
          (timeUntilEnd > 0 && timeUntilEnd <= 15)) {
        foodCount++;
      }
    }
    return foodCount;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"), 
        backgroundColor: Colors.red,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "Event Notifications"),
            Tab(text: "Food Notifications"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EventNotificationsTab(),
          FoodCounterNotificationsTab(),
        ],
      ),
    );
  }
}

// Event Notifications Tab

class EventNotificationsTab extends StatefulWidget {
  @override
  _EventNotificationsTabState createState() => _EventNotificationsTabState();
}

class _EventNotificationsTabState extends State<EventNotificationsTab> {
  List<Map<String, dynamic>> upcomingEvents = [];
  List<Map<String, dynamic>> allEventsOfTheDay = [];

  @override
  void initState() {
    super.initState();
    loadEventData();
  }

  Future<void> loadEventData() async {
    final String response = await rootBundle.loadString('assets/events.json');
    final Map<String, dynamic> data = json.decode(response);
    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    List<Map<String, dynamic>> eventsToday = [];
    List<Map<String, dynamic>> eventsToNotify = [];

    if (data.containsKey(todayKey)) {
      for (var event in data[todayKey]) {
        DateTime eventDateTime = DateTime.parse(event['time']);
        final timeDifference = eventDateTime.difference(now).inMinutes;

        if (timeDifference > 0) {
          eventsToday.add({
            'title': event['title'],
            'venue': event['venue'],
            'time': DateFormat.jm().format(eventDateTime),
          });
        }

        if (timeDifference <= 30 && timeDifference > 0) {
          eventsToNotify.add({
            'title': event['title'],
            'venue': event['venue'],
            'time': DateFormat.jm().format(eventDateTime),
            'minutesLeft': timeDifference,
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
      builder: (context) {
        return AlertDialog(
          title: Text("Hurry Up!"),
          content: Text("$eventTitle is about to start at $eventVenue."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highContrastTextColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final cardBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey[800]
        : Colors.lightBlue[50];
    final notificationBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.orange[800]
        : Colors.orange[100];

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          "All Events Today",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: highContrastTextColor),
        ),
        SizedBox(height: 10),
        ...allEventsOfTheDay.map((event) {
          return ListTile(
            title: Text(
              "${event['title']} at ${event['venue']} - ${event['time']}",
              style: TextStyle(fontSize: 18, color: highContrastTextColor),
            ),
            tileColor: cardBackgroundColor,
          );
        }).toList(),
        SizedBox(height: 20),
        Text(
          "Upcoming Events (Next 30 Minutes)",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: highContrastTextColor),
        ),
        ...upcomingEvents.map((event) {
          return ListTile(
            title: Text(
              "Hurry up! ${event['title']} is going to start at ${event['venue']} in ${event['minutesLeft']} minutes",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: highContrastTextColor),
            ),
            tileColor: notificationBackgroundColor,
          );
        }).toList(),
      ],
    );
  }
}

// Food Counter Notifications Tab

class FoodCounterNotificationsTab extends StatefulWidget {
  @override
  _FoodCounterNotificationsTabState createState() =>
      _FoodCounterNotificationsTabState();
}

class _FoodCounterNotificationsTabState
    extends State<FoodCounterNotificationsTab> {
  List<String> notifications = []; // Notifications to display as text

  @override
  void initState() {
    super.initState();
    loadFoodData();
  }

  Future<void> loadFoodData() async {
    final String response = await rootBundle.loadString('assets/food.json');
    final List<dynamic> data = json.decode(response);
    final now = DateTime.now();

    notifications.clear(); // Clear previous notifications

    for (var foodItem in data) {
      DateTime foodStartTime = DateTime.parse(foodItem['startTime']);
      DateTime foodEndTime = DateTime.parse(foodItem['expiryTime']);

      final timeUntilStart = foodStartTime.difference(now).inMinutes;
      final timeUntilEnd = foodEndTime.difference(now).inMinutes;

      // Add notification message if the item is 15 minutes from start or end
      if (timeUntilStart > 0 && timeUntilStart <= 15) {
        notifications.add(
            "Hurry up! ${foodItem['name']} is going to start in $timeUntilStart minutes.");
      }
      if (timeUntilEnd > 0 && timeUntilEnd <= 15) {
        notifications.add(
            "Hurry up! ${foodItem['name']} is going to end in $timeUntilEnd minutes.");
      }
    }

    setState(() {
      // Updates the notifications list only
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: notifications.isNotEmpty
//           ? ListView.builder(
//               padding: EdgeInsets.all(16),
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 5,
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: Text(
//                       notifications[index],
//                       style: TextStyle(fontSize: 18 ,),
//                     ),
//                   ),
//                 );
//               },
//             )
//           : Center(
//               child: Text(
//                 "No food notifications at the moment.",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notifications.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                // Splitting the message to format the item name in bold
                final parts = notifications[index].split(" ");
                final itemName = parts[2]; // Extracting item name

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Card(
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          children: [
                            TextSpan(text: "Hurry up! "),
                            TextSpan(
                              text: itemName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            TextSpan(
                              text: " " +
                                  parts.skip(3).join(
                                      " "), // Joining the rest of the message
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "No notifications at this time",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
    );
  }
}
