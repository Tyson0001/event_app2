// // // import 'package:flutter/material.dart';
// // //  // Import the FirstPage
// // // import '../models/user.dart';

// // // class HomePage extends StatelessWidget {
// // //   final List<Map<String, String>> events = [
// // //     {'title': 'Himalayas Startup Trek', 'date': '2024-11-15', 'location': 'Hall A'},
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Home'),
// // //         backgroundColor: Colors.red,
// // //         actions: [
// // //           // IconButton for profile navigation
// // //           IconButton(
// // //             icon: Icon(Icons.person),
// // //             onPressed: () {
// // //               final user = User(username: 'SampleUser', email: 'user@example.com', password: 'password123');
// // //               Navigator.pushNamed(context, '/profile', arguments: user);
// // //             },
// // //           ),
// // //           // Removed IconButton to navigate to FirstPage
// // //         ],
// // //       ),
// // //       body: Container(
// // //         color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.5),
// // //         child: ListView.builder(
// // //           itemCount: events.length,
// // //           itemBuilder: (context, index) {
// // //             final event = events[index];
// // //             return Card(
// // //               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               elevation: 4,
// // //               color: isDarkMode ? Colors.grey[800] : Colors.white,
// // //               child: ListTile(
// // //                 title: Text(
// // //                   event['title']!,
// // //                   style: TextStyle(
// // //                     fontWeight: FontWeight.bold,
// // //                     color: isDarkMode ? Colors.white : Colors.black,
// // //                   ),
// // //                 ),
// // //                 subtitle: Text(
// // //                   '${event['date']} - ${event['location']}',
// // //                   style: TextStyle(
// // //                     color: isDarkMode ? Colors.white70 : Colors.black87,
// // //                   ),
// // //                 ),
// // //                 onTap: () {
// // //                   Navigator.pushNamed(
// // //                     context,
// // //                     '/eventDetails',
// // //                     arguments: event,
// // //                   );
// // //                 },
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import '../models/user.dart';
// // import 'first_page.dart'; // Import the FirstPage

// // class HomePage extends StatelessWidget {
// //   final List<Map<String, String>> events = [
// //     {
// //       'title': 'Himalayas Startup Trek',
// //       'date': '2024-11-15',
// //       'location': 'Hall A'
// //     },
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Home'),
// //         backgroundColor: Colors.red,
// //         actions: [
// //           // IconButton for profile navigation
// //           IconButton(
// //             icon: Icon(Icons.person),
// //             onPressed: () {
// //               final user = User(
// //                   username: 'SampleUser',
// //                   email: 'user@example.com',
// //                   password: 'password123');
// //               Navigator.pushNamed(context, '/profile', arguments: user);
// //             },
// //           ),
// //           // IconButton to navigate to FirstPage
// //           IconButton(
// //             icon: Icon(Icons.list),
// //             onPressed: () {
// //               Navigator.push(
// //                   context, MaterialPageRoute(builder: (context) => FirstPage())); // Navigate to FirstPage
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         color: isDarkMode
// //             ? Colors.black.withOpacity(0.7)
// //             : Colors.white.withOpacity(0.5),
// //         child: ListView.builder(
// //           itemCount: events.length,
// //           itemBuilder: (context, index) {
// //             final event = events[index];
// //             return Card(
// //               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               elevation: 4,
// //               color: isDarkMode ? Colors.grey[800] : Colors.white,
// //               child: ListTile(
// //                 title: Text(
// //                   event['title']!,
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     color: isDarkMode ? Colors.white : Colors.black,
// //                   ),
// //                 ),
// //                 subtitle: Text(
// //                   '${event['date']} - ${event['location']}',
// //                   style: TextStyle(
// //                     color: isDarkMode ? Colors.white70 : Colors.black87,
// //                   ),
// //                 ),
// //                 onTap: () {
// //                   Navigator.pushNamed(
// //                     context,
// //                     '/eventDetails',
// //                     arguments: event,
// //                   );
// //                 },
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }




























// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import 'first_page.dart'; // Import the FirstPage

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<Map<String, String>> events = [
//     {
//       'title': 'Himalayas Startup Trek',
//       'date': '2024-11-15',
//       'location': 'Hall A',
//       'eventCode': 'qwerty'
//     },
//     {
//       'title': 'Tech Summit 2024',
//       'date': '2024-12-01',
//       'location': 'Hall B',
//       'eventCode': '123456'
//     },
//     {
//       'title': 'AI Conference',
//       'date': '2025-01-10',
//       'location': 'Main Auditorium',
//       'eventCode': '789101'
//     },
//   ];



//   String searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     final filteredEvents = events
//         .where((event) =>
//             event['eventCode']!.contains(searchQuery) ||
//             event['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         backgroundColor: Colors.red,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.person),
//             onPressed: () {
//               final user = User(
//                 username: 'SampleUser',
//                 email: 'user@example.com',
//                 password: 'password123',
//               );
//               Navigator.pushNamed(context, '/profile', arguments: user);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.list),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FirstPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Search by Event Code or Title',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   searchQuery = value;
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: filteredEvents.isEmpty
//                 ? Center(
//                     child: Text(
//                       'No events match your search.',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   )
//                 : Container(
//                     color: isDarkMode
//                         ? Colors.black.withOpacity(0.7)
//                         : Colors.white.withOpacity(0.5),
//                     child: ListView.builder(
//                       itemCount: filteredEvents.length,
//                       itemBuilder: (context, index) {
//                         final event = filteredEvents[index];
//                         return Card(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                           color:
//                               isDarkMode ? Colors.grey[800] : Colors.white,
//                           child: ListTile(
//                             title: Text(
//                               event['title']!,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: isDarkMode
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                             subtitle: Text(
//                               '${event['date']} - ${event['location']}\nCode: ${event['eventCode']}',
//                               style: TextStyle(
//                                 color: isDarkMode
//                                     ? Colors.white70
//                                     : Colors.black87,
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 '/eventDetails',
//                                 arguments: event,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }




























































import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'first_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> events = [];
  String searchQuery = '';
  bool isLoading = true;
  final String apiUrl = 'https://gatherhub-r7yr.onrender.com/user/conference/';

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  String formatDate(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return isoString;
    }
  }

  Future<void> loadEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? eventsJson = prefs.getString('conferences_stored');

      if (eventsJson != null) {
        final List<dynamic> decodedEvents = json.decode(eventsJson);
        setState(() {
          events = decodedEvents.map((event) {
            return Map<String, String>.from(event);
          }).toList();
          isLoading = false;
        });
      } else {
        await fetchEventsFromUrl();
      }
    } catch (e) {
      print('Error loading events: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorMessage('Error loading events. Please try again.');
    }
  }

  String _safeToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Future<void> fetchEventsFromUrl() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Map<String, String>> fetchedEvents = data.map((event) {
          // Safely convert all values to strings
          return {
            'conferenceCode': _safeToString(event['conferenceCode']),
            'name': _safeToString(event['name']),
            'startDate': event['startDate'] != null 
              ? formatDate(_safeToString(event['startDate']))
              : '',
            'location': _safeToString(event['location']),
            // Add any other fields you need, using _safeToString
          };
        }).toList();

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('conferences_stored', json.encode(fetchedEvents));

        setState(() {
          events = fetchedEvents;
          isLoading = false;
        });
        _showErrorMessage('Events updated successfully!');
      } else {
        throw Exception('Failed to load events from server');
      }
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorMessage('Error updating events. Please try again.');
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final filteredEvents = events.where((event) =>
        event['conferenceCode']!.contains(searchQuery) ||
        event['name']!.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchEventsFromUrl,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              final user = User(
                username: 'SampleUser',
                email: 'user@example.com',
                password: 'password123',
              );
              Navigator.pushNamed(context, '/profile', arguments: user);
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirstPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Event Code or Title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredEvents.isEmpty
                    ? Center(
                        child: Text(
                          'No events match your search.',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      )
                    : Container(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.7)
                            : Colors.white.withOpacity(0.5),
                        child: ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              color:
                                  isDarkMode ? Colors.grey[800] : Colors.white,
                              child: ListTile(
                                title: Text(
                                  event['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  '${event['startDate']} - ${event['location']}\nCode: ${event['conferenceCode']}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/eventDetails',
                                    arguments: event,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}