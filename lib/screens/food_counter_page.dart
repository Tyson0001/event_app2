import 'package:flutter/material.dart';
import 'dart:async';

class FoodCounterPage extends StatefulWidget {
  @override
  _FoodCounterPageState createState() => _FoodCounterPageState();
}

class _FoodCounterPageState extends State<FoodCounterPage> {
  List<FoodItem> foodItems = [
    FoodItem(name: "Pizza", description: "Cheese & Tomato", expiryTime: DateTime.now().add(Duration(seconds: 10))),
    FoodItem(name: "Pasta", description: "Creamy Alfredo", expiryTime: DateTime.now().add(Duration(seconds: 20))),
    FoodItem(name: "Salad", description: "Fresh Veggies", expiryTime: DateTime.now().add(Duration(seconds: 30))),
  ];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkExpiredItems());
  }

  void checkExpiredItems() {
    final currentTime = DateTime.now();
    setState(() {
      foodItems.removeWhere((item) => item.expiryTime.isBefore(currentTime));
    });
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
      body: foodItems.isNotEmpty
          ? ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            trailing: Text("Expires at: ${item.expiryTime.hour}:${item.expiryTime.minute}:${item.expiryTime.second}"),
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
  final DateTime expiryTime;

  FoodItem({required this.name, required this.description, required this.expiryTime});
}
