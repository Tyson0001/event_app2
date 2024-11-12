// lib/services/api_service.dart

import 'package:flutter/material.dart';
import '../models/event.dart';

class ApiService {
  // Mock data for demonstration
  List<Event> fetchEvents() {
    return [
      Event(
        title: 'Flutter Workshop',
        description: 'A hands-on workshop to learn Flutter.',
        date: DateTime.parse('2023-03-10'), // Using DateTime
        time: TimeOfDay(hour: 10, minute: 0), // Using TimeOfDay
        imageUrl: 'https://example.com/flutter_workshop.jpg',
      ),
      Event(
        title: 'Dart Conference',
        description: 'Learn about the latest in Dart development.',
        date: DateTime.parse('2023-04-15'), // Using DateTime
        time: TimeOfDay(hour: 9, minute: 0), // Using TimeOfDay
        imageUrl: 'https://example.com/dart_conference.jpg',
      ),
    ];
  }
}
