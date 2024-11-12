// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
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
            final user = settings.arguments as User;
            return MaterialPageRoute(
              builder: (context) => UserProfilePage(user: user),
            );
          default:
            return null;
        }
      },
    );
  }
}
