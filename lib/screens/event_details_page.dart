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

















// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'event_schedule_page.dart';
// import 'detail_page.dart';
// import 'directory_page.dart';
// import 'sponsors_page.dart';
// import 'mentor_page.dart';
// import 'helpline_page.dart';
// import 'notifications_page.dart';
// import 'food_counter_page.dart';

// class EventDetailsPage extends StatefulWidget {
//   final Map<String, String> event;

//   const EventDetailsPage({Key? key, required this.event}) : super(key: key);

//   @override
//   _EventDetailsPageState createState() => _EventDetailsPageState();
// }

// class _EventDetailsPageState extends State<EventDetailsPage> {
//   int notificationCount = 0;
//   List<Uint8List>? eventImages;
//   late String imagesUrl;
//   final String imagesKey = 'eventImagesKey';

//   @override
//   void initState() {
//     super.initState();
//     imagesUrl = 'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/images';
//     _loadInitialData();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadEventImages();
//   }

//   Future<void> _loadInitialData() async {
//     await Future.wait([
//       _loadNotificationCount(),
//       _loadEventImages(),
//     ]);
//   }

//   Future<void> _loadNotificationCount() async {
//     try {
//       notificationCount = await fetchNotificationCount();
//       if (mounted) {
//         setState(() {});
//       }
//     } catch (e) {
//       print('Error loading notification count: $e');
//     }
//   }

//   Future<int> fetchNotificationCount() async {
//     // Replace with actual API call
//     await Future.delayed(const Duration(seconds: 1));
//     return 5;
//   }

//   Future<void> _loadEventImages() async {
//     try {
//       bool fetchedFromUrl = await _fetchAndStoreImages();
//       if (!fetchedFromUrl && mounted) {
//         await _loadImagesFromSharedPreferences();
//       }
//     } catch (e) {
//       print('Error loading event images: $e');
//     }
//   }

//   Future<bool> _fetchAndStoreImages() async {
//     try {
//       final response = await http.get(Uri.parse(imagesUrl));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
        
//         List<String> base64Images = data
//             .map<String>((image) => image['photo'] as String)
//             .where((image) => image.isNotEmpty)
//             .toList();

//         if (base64Images.isEmpty) {
//           return false;
//         }

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setStringList(imagesKey, base64Images);

//         if (mounted) {
//           setState(() {
//             eventImages = base64Images.map((img) => base64Decode(img)).toList();
//           });
//         }

//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Error fetching event images: $e');
//       return false;
//     }
//   }

//   Future<void> _loadImagesFromSharedPreferences() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final storedImages = prefs.getStringList(imagesKey);

//       if (storedImages != null && storedImages.isNotEmpty && mounted) {
//         setState(() {
//           eventImages = storedImages.map((img) => base64Decode(img)).toList();
//         });
//       }
//     } catch (e) {
//       print('Error loading images from SharedPreferences: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(widget.event['title'] ?? 'Event Details'),
//         actions: [
//           _buildNotificationButton(),
//           IconButton(
//             icon: const Icon(Icons.contact_phone),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HelplinePage(event: widget.event),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildImageCarousel(),
//           const SizedBox(height: 16),
//           Expanded(
//             child: _buildGridButtons(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationButton() {
//     return Stack(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.notifications),
//           onPressed: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NotificationsPage(
//                 onNotificationUpdate: (totalNotifications) {
//                   if (mounted) {
//                     setState(() => notificationCount = totalNotifications);
//                   }
//                 },
//               ),
//             ),
//           ),
//         ),
//         if (notificationCount > 0)
//           Positioned(
//             right: 11,
//             top: 11,
//             child: Container(
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               constraints: const BoxConstraints(
//                 minWidth: 16,
//                 minHeight: 16,
//               ),
//               child: Text(
//                 '$notificationCount',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildImageCarousel() {
//     return SizedBox(
//       height: 200.0,
//       child: eventImages == null
//           ? const Center(child: CircularProgressIndicator())
//           : PageView.builder(
//               itemCount: eventImages!.length,
//               itemBuilder: (context, index) {
//                 return Image.memory(
//                   eventImages![index],
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Center(
//                       child: Icon(Icons.error_outline, size: 40),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }

//   Widget _buildGridButtons() {
//     final List<Map<String, dynamic>> buttons = [
//       {
//         'label': 'Sponsors',
//         'icon': Icons.attach_money,
//         'page': SponsorPage(event: widget.event),
//       },
//       {
//         'label': 'Directory',
//         'icon': Icons.book,
//         'page': DirectoryPage(),
//       },
//       {
//         'label': 'Event Schedule',
//         'icon': Icons.schedule,
//         'page': EventSchedulePage(event: widget.event),
//       },
//       {
//         'label': 'Details',
//         'icon': Icons.info,
//         'page': DetailPage(event: widget.event),
//       },
//       {
//         'label': 'Mentor',
//         'icon': Icons.person,
//         'page': MentorPage(event: widget.event),
//       },
//       {
//         'label': 'Food Counter',
//         'icon': Icons.fastfood,
//         'page': FoodCounterPage(event: widget.event),
//       },
//     ];

//     return GridView.count(
//       crossAxisCount: 2,
//       childAspectRatio: 1.5,
//       padding: const EdgeInsets.all(8.0),
//       children: buttons.map((button) => _buildGridButton(
//         context,
//         label: button['label'],
//         icon: button['icon'],
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => button['page']),
//         ),
//       )).toList(),
//     );
//   }

//   Widget _buildGridButton(
//     BuildContext context, {
//     required String label,
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Card(
//         margin: const EdgeInsets.all(8.0),
//         color: Colors.red,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40, color: Colors.white),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.white),
//               ),
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

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int notificationCount = 0;
  List<Uint8List>? eventImages;
  late String imagesUrl;
  final String imagesKey = 'eventImagesKey';

  @override
  void initState() {
    super.initState();
    imagesUrl = 'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/images';
    _loadInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEventImages();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadNotificationCount(),
      _loadEventImages(),
    ]);
  }

  Future<void> _loadNotificationCount() async {
    try {
      notificationCount = await fetchNotificationCount();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading notification count: $e');
    }
  }

  Future<int> fetchNotificationCount() async {
    // Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    return 5;
  }

  String _cleanBase64String(String base64String) {
    // Remove data URL prefix if present
    if (base64String.contains(';base64,')) {
      return base64String.split(';base64,')[1];
    }
    return base64String;
  }

  Future<void> _loadEventImages() async {
    try {
      bool fetchedFromUrl = await _fetchAndStoreImages();
      if (!fetchedFromUrl && mounted) {
        await _loadImagesFromSharedPreferences();
      }
    } catch (e) {
      print('Error loading event images: $e');
    }
  }

  Future<bool> _fetchAndStoreImages() async {
    try {
      final response = await http.get(Uri.parse(imagesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<String> base64Images = data
            .map<String>((image) => image['photo'] as String)
            .where((image) => image.isNotEmpty)
            .map((image) => _cleanBase64String(image))
            .toList();

        if (base64Images.isEmpty) {
          return false;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(imagesKey, base64Images);

        if (mounted) {
          setState(() {
            eventImages = base64Images.map((img) => base64Decode(img)).toList();
          });
        }

        return true;
      }
      return false;
    } catch (e) {
      print('Error fetching event images: $e');
      return false;
    }
  }

  Future<void> _loadImagesFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedImages = prefs.getStringList(imagesKey);

      if (storedImages != null && storedImages.isNotEmpty && mounted) {
        setState(() {
          eventImages = storedImages.map((img) => base64Decode(img)).toList();
        });
      }
    } catch (e) {
      print('Error loading images from SharedPreferences: $e');
      if (e is FormatException) {
        print('Invalid base64 format detected. Clearing stored images...');
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(imagesKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.event['title'] ?? 'Event Details'),
        actions: [
          _buildNotificationButton(),
          IconButton(
            icon: const Icon(Icons.contact_phone),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelplinePage(event: widget.event),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildImageCarousel(),
          const SizedBox(height: 24), // change height of sliding bar
          Expanded(
            child: _buildGridButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsPage(
                onNotificationUpdate: (totalNotifications) {
                  if (mounted) {
                    setState(() => notificationCount = totalNotifications);
                  }
                },
              ),
            ),
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 11,
            top: 11,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(100),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 200.0,
      child: eventImages == null || eventImages!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              itemCount: eventImages!.length,
              itemBuilder: (context, index) {
                return Image.memory(
                  eventImages![index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image at index $index: $error');
                    return const Center(
                      child: Icon(Icons.error_outline, size: 40),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildGridButtons() {
    final List<Map<String, dynamic>> buttons = [
      {
        'label': 'Sponsors',
        'icon': Icons.attach_money,
        'page': SponsorPage(event: widget.event),
      },
      {
        'label': 'Directory',
        'icon': Icons.book,
        'page': DirectoryPage(),
      },
      {
        'label': 'Event Schedule',
        'icon': Icons.schedule,
        'page': EventSchedulePage(event: widget.event),
      },
      {
        'label': 'Details',
        'icon': Icons.info,
        'page': DetailPage(event: widget.event),
      },
      {
        'label': 'Mentor',
        'icon': Icons.person,
        'page': MentorPage(event: widget.event),
      },
      {
        'label': 'Food Counter',
        'icon': Icons.fastfood,
        'page': FoodCounterPage(event: widget.event),
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      padding: const EdgeInsets.all(8.0),
      children: buttons.map((button) => _buildGridButton(
        context,
        label: button['label'],
        icon: button['icon'],
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => button['page']),
        ),
      )).toList(),
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
        margin: const EdgeInsets.all(8.0),
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}