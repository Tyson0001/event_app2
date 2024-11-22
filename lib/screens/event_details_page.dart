
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

//   String _cleanBase64String(String base64String) {
//     // Remove data URL prefix if present
//     if (base64String.contains(';base64,')) {
//       return base64String.split(';base64,')[1];
//     }
//     return base64String;
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
//             .map((image) => _cleanBase64String(image))
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
//       if (e is FormatException) {
//         print('Invalid base64 format detected. Clearing stored images...');
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.remove(imagesKey);
//       }
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
//       child: eventImages == null || eventImages!.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : PageView.builder(
//               itemCount: eventImages!.length,
//               itemBuilder: (context, index) {
//                 return Image.memory(
//                   eventImages![index],
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     print('Error loading image at index $index: $error');
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
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     imagesUrl = 'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/images';
//     _loadInitialData();
//   }

//   Future<void> _loadInitialData() async {
//     try {
//       await Future.wait([
//         _loadNotificationCount(),
//         _fetchImages(),
//       ]);
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
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

//   String _cleanBase64String(String base64String) {
//     if (base64String.contains(';base64,')) {
//       return base64String.split(';base64,')[1];
//     }
//     return base64String;
//   }

//   Future<void> _fetchImages() async {
//     try {
//       final response = await http.get(Uri.parse(imagesUrl));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
        
//         List<String> base64Images = data
//             .map<String>((image) => image['photo'] as String)
//             .where((image) => image.isNotEmpty)
//             .map((image) => _cleanBase64String(image))
//             .toList();

//         if (base64Images.isNotEmpty) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setStringList(imagesKey, base64Images);

//           if (mounted) {
//             setState(() {
//               eventImages = base64Images.map((img) => base64Decode(img)).toList();
//             });
//           }
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to load images. Please restart the app to try again.')),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error fetching event images: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error loading images. Please check your connection and restart the app.')),
//         );
//       }
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

//   Widget _buildImageCarousel() {
//     return SizedBox(
//       height: 200.0,
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : eventImages == null || eventImages!.isEmpty
//               ? const Center(
//                   child: Text('No images available'),
//                 )
//               : PageView.builder(
//                   itemCount: eventImages!.length,
//                   itemBuilder: (context, index) {
//                     return Image.memory(
//                       eventImages![index],
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         print('Error loading image at index $index: $error');
//                         return const Center(
//                           child: Icon(Icons.error_outline, size: 40),
//                         );
//                       },
//                     );
//                   },
//                 ),
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
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     imagesUrl = 'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/images';
//     _loadNotificationCount();
//     // Remove automatic image loading from initState
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

//   String _cleanBase64String(String base64String) {
//     if (base64String.contains(';base64,')) {
//       return base64String.split(';base64,')[1];
//     }
//     return base64String;
//   }

//   Future<void> _reloadImages() async {
//     if (isLoading) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.get(Uri.parse(imagesUrl));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
        
//         List<String> base64Images = data
//             .map<String>((image) => image['photo'] as String)
//             .where((image) => image.isNotEmpty)
//             .map((image) => _cleanBase64String(image))
//             .toList();

//         if (base64Images.isNotEmpty) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setStringList(imagesKey, base64Images);

//           if (mounted) {
//             setState(() {
//               eventImages = base64Images.map((img) => base64Decode(img)).toList();
//             });
//           }
//         }
//       } else {
//         // Show error message if API call fails
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to load images. Please try again.')),
//         );
//       }
//     } catch (e) {
//       print('Error fetching event images: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error loading images. Please check your connection.')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(widget.event['title'] ?? 'Event Details'),
//         actions: [
//           // Add reload button
//           IconButton(
//             icon: isLoading 
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     color: Colors.white,
//                     strokeWidth: 2,
//                   ),
//                 )
//               : const Icon(Icons.refresh),
//             onPressed: isLoading ? null : _reloadImages,
//           ),
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

//   Widget _buildImageCarousel() {
//     return SizedBox(
//       height: 200.0,
//       child: eventImages == null
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.image, size: 48, color: Colors.grey),
//                   SizedBox(height: 8),
//                   Text(
//                     'Tap refresh to load images',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             )
//           : eventImages!.isEmpty
//               ? const Center(child: Text('No images available'))
//               : PageView.builder(
//                   itemCount: eventImages!.length,
//                   itemBuilder: (context, index) {
//                     return Image.memory(
//                       eventImages![index],
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         print('Error loading image at index $index: $error');
//                         return const Center(
//                           child: Icon(Icons.error_outline, size: 40),
//                         );
//                       },
//                     );
//                   },
//                 ),
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    imagesUrl = 'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/images';
    _loadNotificationCount();
    _loadSavedImages();
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
    await Future.delayed(const Duration(seconds: 1));
    return 5;
  }

  String _cleanBase64String(String base64String) {
    if (base64String.contains(';base64,')) {
      return base64String.split(';base64,')[1];
    }
    return base64String;
  }

  Future<void> _loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? base64Images = prefs.getStringList(imagesKey);

    if (base64Images != null && base64Images.isNotEmpty) {
      setState(() {
        eventImages = base64Images.map((img) => base64Decode(img)).toList();
      });
    }
  }

  Future<void> _reloadImages() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(imagesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        List<String> base64Images = data
            .map<String>((image) => image['photo'] as String)
            .where((image) => image.isNotEmpty)
            .map((image) => _cleanBase64String(image))
            .toList();

        if (base64Images.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList(imagesKey, base64Images);

          setState(() {
            eventImages = base64Images.map((img) => base64Decode(img)).toList();
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load images. Please try again.')),
        );
      }
    } catch (e) {
      print('Error fetching event images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading images. Please check your connection.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.event['title'] ?? 'Event Details'),
        actions: [
          IconButton(
            icon: isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.refresh),
            onPressed: isLoading ? null : _reloadImages,
          ),
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
          const SizedBox(height: 16),
          Expanded(
            child: _buildGridButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 350.0,
      child: eventImages == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Tap refresh to load images',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : eventImages!.isEmpty
              ? const Center(child: Text('No images available'))
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
                  setState(() => notificationCount = totalNotifications);
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
