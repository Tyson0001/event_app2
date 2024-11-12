// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/event_details_page.dart'; // Import event details page
import 'models/user.dart';
import 'utils/constants.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            if (settings.arguments is User) {
              final user = settings.arguments as User;
              return MaterialPageRoute(
                builder: (context) => UserProfilePage(user: user),
              );
            }
            return _errorRoute();
          case '/eventDetails':
            if (settings.arguments is Map<String, String>) {
              final event = settings.arguments as Map<String, String>;
              return MaterialPageRoute(
                builder: (context) => EventDetailsPage(event: event),
              );
            }
            return _errorRoute();
          default:
            return _errorRoute();
        }
      },
    );
  }

  // A fallback route for any unhandled or incorrect arguments
  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("Page not found or invalid arguments.")),
      ),
    );
  }
}
