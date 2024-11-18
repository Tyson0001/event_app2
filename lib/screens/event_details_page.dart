// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'event_schedule_page.dart';
// import 'detail_page.dart';
// import 'directory_page.dart';
// import 'sponsors_page.dart';
// import 'mentor_page.dart';
// import 'helpline_page.dart';
// import 'notifications_page.dart';
// import 'food_counter_page.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class EventDetailsPage extends StatefulWidget {
//   final Map<String, String> event;

//   EventDetailsPage({required this.event});

//   @override
//   _EventDetailsPageState createState() => _EventDetailsPageState();
// }

// class _EventDetailsPageState extends State<EventDetailsPage> {
//   int notificationCount = 0;
//   List<Uint8List>? eventImages;

//   // get event => null;

//   @override
//   void initState() {
//     super.initState();
//     _loadNotificationCount(); // Load notification count on initialization
//     _loadEventImages(); // Load images from event_images.json
//   }

//   /// Load notification count (example logic, replace with real data source)
//   void _loadNotificationCount() async {
//     notificationCount = await fetchNotificationCount();
//     setState(() {}); // Update the UI with the new notification count
//   }

//   Future<int> fetchNotificationCount() async {
//     await Future.delayed(Duration(seconds: 0)); // Simulating a delay
//     return 5; // Example notification count
//   }

//   /// Load event images from event_images.json
//   Future<void> _loadEventImages() async {
//     try {
//       final String response =
//           await rootBundle.loadString('assets/event_images.json');
//       final List<dynamic> data = json.decode(response);

//       setState(() {
//         eventImages = data.map((image) {
//           return base64Decode(image['eventimage']); // Decode Base64 string
//         }).toList();
//       });
//     } catch (e) {
//       print("Error loading event images: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(widget.event['title'] ?? 'Event Details'),
//         actions: [
//           // Notifications Icon
//           Stack(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.notifications),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => NotificationsPage(
//                         onNotificationUpdate: (int totalNotifications) {
//                           setState(() {
//                             notificationCount = totalNotifications;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               if (notificationCount > 0)
//                 Positioned(
//                   right: 11,
//                   top: 11,
//                   child: Container(
//                     padding: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     constraints: BoxConstraints(
//                       minWidth: 16,
//                       minHeight: 16,
//                     ),
//                     child: Text(
//                       '$notificationCount',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           IconButton(
//             icon: Icon(Icons.contact_phone),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => HelplinePage(event: widget.event)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Image Carousel
//           Container(
//             height: 200.0,
//             child: eventImages == null
//                 ? Center(child: CircularProgressIndicator())
//                 : PageView.builder(
//                     itemCount: eventImages!.length,
//                     itemBuilder: (context, index) {
//                       return Image.memory(
//                         eventImages![index],
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//           ),
//           SizedBox(height: 16),
//           // Grid Buttons
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 2,
//               childAspectRatio: 1.5,
//               padding: EdgeInsets.all(8.0),
//               children: [
//                 _buildGridButton(
//                   context,
//                   label: 'Sponsors',
//                   icon: Icons.attach_money,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SponsorsPage()),
//                     );
//                   },
//                 ),
//                 _buildGridButton(
//                   context,
//                   label: 'Directory',
//                   icon: Icons.book,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => DirectoryPage()),
//                     );
//                   },
//                 ),
//                 _buildGridButton(
//                   context,
//                   label: 'Event Schedule',
//                   icon: Icons.schedule,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => EventSchedulePage(event: widget.event)),
//                     );
//                   },
//                 ),
//                 _buildGridButton(
//                   context,
//                   label: 'Details',
//                   icon: Icons.info,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => DetailPage(event: widget.event)),
//                     );
//                   },
//                 ),
//                 _buildGridButton(
//                   context,
//                   label: 'Mentor',
//                   icon: Icons.person,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => MentorPage(event: widget.event)),
//                     );
//                   },
//                 ),
//                 _buildGridButton(
//                   context,
//                   label: 'Food Counter',
//                   icon: Icons.fastfood,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => FoodCounterPage(event: widget.event)),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Helper function to build grid buttons
//   Widget _buildGridButton(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Card(
//         margin: EdgeInsets.all(8.0),
//         color: Colors.red,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40, color: Colors.white),
//               SizedBox(height: 8),
//               Text(label, style: TextStyle(color: Colors.white)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'event_schedule_page.dart';
import 'detail_page.dart';
import 'directory_page.dart';
import 'sponsors_page.dart';
import 'mentor_page.dart';
import 'helpline_page.dart';
import 'notifications_page.dart';
import 'food_counter_page.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, String> event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int notificationCount = 0;
  List<Uint8List>? eventImages;
  final String imagesUrl =
      'https://gatherhub-r7yr.onrender.com/user/conference/qwerty/eventCard/images'; // Replace with your URL
  final String imagesKey = 'eventImagesKey'; // Key for SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEventImages(); // Try to load images every time the page is opened
  }

  Future<void> _loadNotificationCount() async {
    notificationCount = await fetchNotificationCount();
    setState(() {});
  }

  Future<int> fetchNotificationCount() async {
    await Future.delayed(Duration(seconds: 0));
    return 5;
  }

  /// Attempt to load event images from URL and save to SharedPreferences;
  /// If fetch fails, load images from SharedPreferences instead.
  Future<void> _loadEventImages() async {
    bool fetchedFromUrl = await _fetchAndStoreImages();
    if (!fetchedFromUrl) {
      // If fetch from URL fails, load from SharedPreferences
      await _loadImagesFromSharedPreferences();
    }
  }

  /// Fetch images from URL and save to SharedPreferences
  Future<bool> _fetchAndStoreImages() async {
    try {
      final response = await http.get(Uri.parse(imagesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        //      ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('images loaded successfully ${data}')),
        // );

        // Convert images to Base64 and store in SharedPreferences
        List<String> base64Images = data.map<String>((image) {
          return image['photo']; // Assuming JSON contains Base64 strings
        }).toList();

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //         'Images loaded unsuccessfully: ${response.body}'),
        //   ),
        // );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(imagesKey, base64Images);

        // Decode Base64 and update eventImages
        setState(() {
          eventImages = base64Images.map((img) => base64Decode(img)).toList();
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       content: Text('images loaded unsuccessfully ${base64Images}')),
        // );

        return true; // Fetch successful
      } else {
        throw Exception("Failed to load images from URL");
      }
    } catch (e) {
      print("Error fetching event images: $e");
      return false; // Fetch failed
    }
  }

  /// Load images from SharedPreferences if they exist
  Future<void> _loadImagesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedImages = prefs.getStringList(imagesKey);

    if (storedImages!.isNotEmpty) {
      setState(() {
        eventImages = storedImages.map((img) => base64Decode(img)).toList();
      });
    } else {
      print("No images found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.event['title'] ?? 'Event Details'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(
                        onNotificationUpdate: (int totalNotifications) {
                          setState(() {
                            notificationCount = totalNotifications;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.contact_phone),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HelplinePage(event: widget.event)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Carousel
          Container(
            height: 200.0,
            child: eventImages == null
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
                    itemCount: eventImages!.length,
                    itemBuilder: (context, index) {
                      return Image.memory(
                        eventImages![index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          SizedBox(height: 16),
          // Grid Buttons
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
                      MaterialPageRoute(builder: (context) => SponsorPage(event: widget.event)),
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
                      MaterialPageRoute(
                          builder: (context) =>
                              EventSchedulePage(event: widget.event)),
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
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(event: widget.event)),
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
                      MaterialPageRoute(
                          builder: (context) =>
                              MentorPage(event: widget.event)),
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
                      MaterialPageRoute(
                          builder: (context) =>
                              FoodCounterPage(event: widget.event)),
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
