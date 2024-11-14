// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:intl/intl.dart'; // Import intl package for date formatting

// class FoodCounterPage extends StatefulWidget {
//   @override
//   _FoodCounterPageState createState() => _FoodCounterPageState();
// }

// class _FoodCounterPageState extends State<FoodCounterPage> {
//   List<FoodItem> foodItems = [
//     FoodItem(
//       name: "Pizza",
//       description: "Cheese & Tomato",
//       startTime: DateTime.now(),
//       expiryTime: DateTime.now().add(Duration(minutes: 10)), // 10 minutes
//     ),
//     FoodItem(
//       name: "Pasta",
//       description: "Creamy Alfredo",
//       startTime: DateTime.now(),
//       expiryTime: DateTime.now().add(Duration(minutes: 20)), // 20 minutes
//     ),
//     FoodItem(
//       name: "Salad",
//       description: "Fresh Veggies",
//       startTime: DateTime.now(),
//       expiryTime: DateTime.now().add(Duration(minutes: 30)), // 30 minutes
//     ),
//   ];

//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkExpiredItems());
//   }

//   void checkExpiredItems() {
//     final currentTime = DateTime.now();
//     setState(() {
//       foodItems.removeWhere((item) => item.expiryTime.isBefore(currentTime));
//     });
//   }

//   String formatTime(DateTime time) {
//     return DateFormat.jm().format(time); // Format time to "4:20 PM" or "3:30 AM"
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
//       body: foodItems.isNotEmpty
//           ? ListView.builder(
//               itemCount: foodItems.length,
//               itemBuilder: (context, index) {
//                 final item = foodItems[index];
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
// }











import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:intl/intl.dart';

class FoodCounterPage extends StatefulWidget {
  @override
  _FoodCounterPageState createState() => _FoodCounterPageState();
}

class _FoodCounterPageState extends State<FoodCounterPage> {
  List<FoodItem> originalFoodItems = [];
  List<FoodItem> displayedFoodItems = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadFoodItems(); // Load items from JSON on init
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => checkExpiredItems());
  }

  Future<void> loadFoodItems() async {
    final String response = await rootBundle.loadString('assets/food.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      originalFoodItems = data.map((item) => FoodItem.fromJson(item)).toList();
      displayedFoodItems = List.from(originalFoodItems); // Initialize displayed list
    });
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

