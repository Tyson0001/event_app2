// lib/utils/constants.dart

import 'package:flutter/material.dart';

class Constants {
  // Base URL for the API
  static const String baseUrl = 'https://yourapi.com/api';

  // API Endpoints
  static const String registerEndpoint = '$baseUrl/register';
  static const String loginEndpoint = '$baseUrl/login';
  static const String profileEndpoint = '$baseUrl/profile';

  // Application Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);

  // General App Strings
  static const String appName = 'My Flutter App';
  static const String welcomeMessage = 'Welcome to My App';
}
