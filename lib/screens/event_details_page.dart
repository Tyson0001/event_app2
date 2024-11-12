import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  final Map<String, String> event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['title']!),
        backgroundColor: Colors.red, // Match the AppBar color with HomePage
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/backgroundimage.jpg', // Path to your background image
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay for readability
          Container(
            color: Colors.black.withOpacity(0.5), // Dark overlay for better text visibility
          ),
          // Event details content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${event['date']}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Location: ${event['location']}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Divider(color: Colors.white, height: 30, thickness: 1),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You have registered for the event!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set button color to match theme
                      minimumSize: Size(200, 50), // Adjust button size
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
