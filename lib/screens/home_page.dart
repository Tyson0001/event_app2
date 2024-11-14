// import 'package:flutter/material.dart';
//  // Import the FirstPage
// import '../models/user.dart';

// class HomePage extends StatelessWidget {
//   final List<Map<String, String>> events = [
//     {'title': 'Himalayas Startup Trek', 'date': '2024-11-15', 'location': 'Hall A'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         backgroundColor: Colors.red,
//         actions: [
//           // IconButton for profile navigation
//           IconButton(
//             icon: Icon(Icons.person),
//             onPressed: () {
//               final user = User(username: 'SampleUser', email: 'user@example.com', password: 'password123');
//               Navigator.pushNamed(context, '/profile', arguments: user);
//             },
//           ),
//           // Removed IconButton to navigate to FirstPage
//         ],
//       ),
//       body: Container(
//         color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.5),
//         child: ListView.builder(
//           itemCount: events.length,
//           itemBuilder: (context, index) {
//             final event = events[index];
//             return Card(
//               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               color: isDarkMode ? Colors.grey[800] : Colors.white,
//               child: ListTile(
//                 title: Text(
//                   event['title']!,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 subtitle: Text(
//                   '${event['date']} - ${event['location']}',
//                   style: TextStyle(
//                     color: isDarkMode ? Colors.white70 : Colors.black87,
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     '/eventDetails',
//                     arguments: event,
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/user.dart';
import 'first_page.dart'; // Import the FirstPage

class HomePage extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      'title': 'Himalayas Startup Trek',
      'date': '2024-11-15',
      'location': 'Hall A'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.red,
        actions: [
          // IconButton for profile navigation
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              final user = User(
                  username: 'SampleUser',
                  email: 'user@example.com',
                  password: 'password123');
              Navigator.pushNamed(context, '/profile', arguments: user);
            },
          ),
          // IconButton to navigate to FirstPage
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FirstPage())); // Navigate to FirstPage
            },
          ),
        ],
      ),
      body: Container(
        color: isDarkMode
            ? Colors.black.withOpacity(0.7)
            : Colors.white.withOpacity(0.5),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: ListTile(
                title: Text(
                  event['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${event['date']} - ${event['location']}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
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
    );
  }
}
