

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:async';
// import 'package:intl/intl.dart';

// class FoodCounterPage extends StatefulWidget {
//   @override
//   _FoodCounterPageState createState() => _FoodCounterPageState();
// }

// class _FoodCounterPageState extends State<FoodCounterPage> {
//   List<FoodItem> originalFoodItems = [];
//   List<FoodItem> displayedFoodItems = [];
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     loadFoodItems(); // Load items from JSON on init
//     timer = Timer.periodic(Duration(seconds: 30), (Timer t) => checkExpiredItems());
//   }

//   Future<void> loadFoodItems() async {
//     final String response = await rootBundle.loadString('assets/food.json');
//     final List<dynamic> data = json.decode(response);

//     setState(() {
//       originalFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
//       displayedFoodItems = List.from(originalFoodItems); // Initialize displayed list
//     });
//   }

//   void checkExpiredItems() {
//     final currentTime = DateTime.now();
//     setState(() {
//       displayedFoodItems.removeWhere((item) => item.expiryTime.isBefore(currentTime));
//     });
//   }

//   String formatTime(DateTime time) {
//     return DateFormat.jm().format(time);
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Food Counter"),
//       ),
//       body: displayedFoodItems.isNotEmpty
//           ? ListView.builder(
//               itemCount: displayedFoodItems.length,
//               itemBuilder: (context, index) {
//                 final item = displayedFoodItems[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.name,
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           item.description,
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "Starting Time: ${formatTime(item.startTime)}",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           "Ending Time: ${formatTime(item.expiryTime)}",
//                           style: TextStyle(fontSize: 16, color: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           : Center(child: Text("No food items available")),
//     );
//   }
// }

// class FoodItem {
//   final String name;
//   final String description;
//   final DateTime startTime;
//   final DateTime expiryTime;

//   FoodItem({
//     required this.name,
//     required this.description,
//     required this.startTime,
//     required this.expiryTime,
//   });

//   // Factory constructor to parse JSON data
//   factory FoodItem.fromJson(Map<String, dynamic> json) {
//     return FoodItem(
//       name: json['name'],
//       description: json['description'],
//       startTime: DateTime.parse(json['startTime']),
//       expiryTime: DateTime.parse(json['expiryTime']),
//     );
//   }
// }








































// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';

// class FoodCounterPage extends StatefulWidget {

//   final Map<String, String> event;

//   FoodCounterPage({required this.event});

//   @override
//   _FoodCounterPageState createState() => _FoodCounterPageState();
// }

// class _FoodCounterPageState extends State<FoodCounterPage> {
//   List<FoodItem> displayedFoodItems = [];
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     loadStoredFoodItems(); // Load data from local storage on app start
//     timer = Timer.periodic(Duration(seconds: 30), (Timer t) => checkExpiredItems());
//   }

//   Future<void> fetchFoodItems(dynamic event) async {
//     final url = 'https://gatherhub-r7yr.onrender.com/user/conference/${event.eventCode}/food'; // Replace with actual API URL

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);

//         setState(() {
//           displayedFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
//         });

//         // Store data in local storage
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('foodData', json.encode(data));

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Food data fetched and stored successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch food data. Status: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching food data: $e')),
//       );
//     }
//   }

//   Future<void> loadStoredFoodItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? storedData = prefs.getString('foodData');

//     if (storedData != null) {
//       final List<dynamic> data = json.decode(storedData);
//       setState(() {
//         displayedFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
//       });
//     }
//   }

//   void checkExpiredItems() {
//     final currentTime = DateTime.now();
//     setState(() {
//       displayedFoodItems.removeWhere((item) => item.expiryTime.isBefore(currentTime));
//     });
//   }

//   String formatTime(DateTime time) {
//     return DateFormat.jm().format(time);
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Food Counter"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             tooltip: 'Reload Food Data',
//             onPressed: () async {
//               await fetchFoodItems(widget.event); // Fetch data when reload icon is pressed
//             },
//           ),
//         ],
//       ),
//       body: displayedFoodItems.isNotEmpty
//           ? ListView.builder(
//               itemCount: displayedFoodItems.length,
//               itemBuilder: (context, index) {
//                 final item = displayedFoodItems[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.name,
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           item.description,
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "Starting Time: ${formatTime(item.startTime)}",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           "Ending Time: ${formatTime(item.expiryTime)}",
//                           style: TextStyle(fontSize: 16, color: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           : Center(child: Text("No food items available")),
//     );
//   }
// }

// class FoodItem {
//   final String name;
//   final String description;
//   final DateTime startTime;
//   final DateTime expiryTime;

//   FoodItem({
//     required this.name,
//     required this.description,
//     required this.startTime,
//     required this.expiryTime,
//   });

//   // Factory constructor to parse JSON data
//   factory FoodItem.fromJson(Map<String, dynamic> json) {
//     return FoodItem(
//       name: json['name'],
//       description: json['description'],
//       startTime: DateTime.parse(json['startTime']),
//       expiryTime: DateTime.parse(json['expiryTime']),
//     );
//   }
// }


























































// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';

// class FoodCounterPage extends StatefulWidget {

//   final Map<String, String> event;

//   FoodCounterPage({required this.event});

//   @override
//   _FoodCounterPageState createState() => _FoodCounterPageState();
// }

// class _FoodCounterPageState extends State<FoodCounterPage> {
//   List<FoodItem> displayedFoodItems = [];
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     loadStoredFoodItems(); // Load data from local storage on app start
//     timer = Timer.periodic(Duration(seconds: 30), (Timer t) => checkExpiredItems());
//   }

//   Future<void> fetchFoodItems(dynamic event) async {
//     final url = 'https://gatherhub-r7yr.onrender.com/user/conference/${event.eventCode}/food'; // Replace with actual API URL

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);

//         setState(() {
//           displayedFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
//         });

//         // Store data in local storage
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('foodData', json.encode(data));

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Food data fetched and stored successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch food data. Status: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching food data: $e')),
//       );
//     }
//   }

//   Future<void> loadStoredFoodItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? storedData = prefs.getString('foodData');

//     if (storedData != null) {
//       final List<dynamic> data = json.decode(storedData);
//       setState(() {
//         displayedFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
//       });
//     }
//   }

//   void checkExpiredItems() {
//     final currentTime = DateTime.now();
//     setState(() {
//       displayedFoodItems.removeWhere((item) => item.expiryTime.isBefore(currentTime));
//     });
//   }

//   String formatTime(DateTime time) {
//     return DateFormat.jm().format(time);
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Food Counter"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             tooltip: 'Reload Food Data',
//             onPressed: () async {
//               await fetchFoodItems(widget.event); // Fetch data when reload icon is pressed
//             },
//           ),
//         ],
//       ),
//       body: displayedFoodItems.isNotEmpty
//           ? ListView.builder(
//               itemCount: displayedFoodItems.length,
//               itemBuilder: (context, index) {
//                 final item = displayedFoodItems[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.name,
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           item.description,
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "Starting Time: ${formatTime(item.startTime)}",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           "Ending Time: ${formatTime(item.expiryTime)}",
//                           style: TextStyle(fontSize: 16, color: Colors.red),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           : Center(child: Text("No food items available")),
//     );
//   }
// }

// class FoodItem {
//   final String name;
//   final String description;
//   final DateTime startTime;
//   final DateTime expiryTime;

//   FoodItem({
//     required this.name,
//     required this.description,
//     required this.startTime,
//     required this.expiryTime,
//   });

//   // Factory constructor to parse JSON data
//   factory FoodItem.fromJson(Map<String, dynamic> json) {
//     return FoodItem(
//       name: json['name'],
//       description: json['description'],
//       startTime: DateTime.parse(json['startTime']),
//       expiryTime: DateTime.parse(json['expiryTime']),
//     );
//   }
// }






















































import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class FoodCounterPage extends StatefulWidget {

  final Map<String, String> event;

  FoodCounterPage({required this.event});

  @override
  _FoodCounterPageState createState() => _FoodCounterPageState();
}

class _FoodCounterPageState extends State<FoodCounterPage> {
  List<FoodItem> displayedFoodItems = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadStoredFoodItems(); // Load data from local storage on app start
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => checkExpiredItems());
  }

  Future<void> fetchFoodItems(dynamic event) async {
    final url = 'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/food'; // Replace with actual API URL

    try {
      final response = await http.get(Uri.parse(url));


      void showSnackbarMessage(BuildContext context, String message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            // duration: Duration(seconds: 3), // Adjust duration as needed
          ),
        );
      }
      // showSnackbarMessage(context, widget.event['eventCode']!);


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          displayedFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
        });

        // Store data in local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('foodData', json.encode(data));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Food data fetched and stored successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch food data. Status: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching food data: $e')),
      );
    }
  }

  Future<void> loadStoredFoodItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('foodData');

    if (storedData != null) {
      final List<dynamic> data = json.decode(storedData);
      setState(() {
        displayedFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
      });
    }
  }

  void checkExpiredItems() {
    final currentTime = DateTime.now();
    setState(() {
      displayedFoodItems.removeWhere((item) => item.expiryTime.isBefore(currentTime));
    });
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Counter"), 
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Reload Food Data',
            onPressed: () async {
              await fetchFoodItems(widget.event); // Fetch data when reload icon is pressed
            },
          ),
        ],
      ),
      body: displayedFoodItems.isNotEmpty
          ? ListView.builder(
              itemCount: displayedFoodItems.length,
              itemBuilder: (context, index) {
                final item = displayedFoodItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Starting Time: ${formatTime(item.startTime)}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Ending Time: ${formatTime(item.expiryTime)}",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("No food items available")),
    );
  }
}

class FoodItem {
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime expiryTime;

  FoodItem({
    required this.name,
    required this.description,
    required this.startTime,
    required this.expiryTime,
  });

  // Factory constructor to parse JSON data
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      expiryTime: DateTime.parse(json['expiryTime']),
    );
  }
}