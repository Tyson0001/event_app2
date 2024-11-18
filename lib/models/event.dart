// lib/models/event.dart

import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String imageUrl;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.imageUrl,
  });

  // Factory method for JSON deserialization
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(":")[0]),
        minute: int.parse(json['time'].split(":")[1]),
      ),
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Method to convert Event instance to JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'time': '${time.hour}:${time.minute}',
    'imageUrl': imageUrl,
  };
}
