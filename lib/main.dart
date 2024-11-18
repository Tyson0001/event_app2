// import 'package:flutter/material.dart';
// import 'screens/first_page.dart';
// import 'screens/home_page.dart';
// import 'screens/login_page.dart';
// import 'screens/registration_page.dart';
// import 'screens/user_profile_page.dart';
// import 'screens/event_details_page.dart'; // Import event details page
// import 'models/user.dart';
// import 'utils/constants.dart';
// import 'theme/app_theme.dart';
// import 'screens/business_card.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: Constants.appName,
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       initialRoute: '/', // Set initial route to FirstPage
//       routes: {
//         '/': (context) => FirstPage(),
//         // Updated to start with FirstPage
//         '/login': (context) => LoginPage(),
//         '/register': (context) => RegistrationPage(),
//         '/home': (context) => HomePage(),
        
//         '/business-card': (context) => const BusinessCardPage(),
//       },
//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//           case '/profile':
//             if (settings.arguments is User) {
//               final user = settings.arguments as User;
//               return MaterialPageRoute(
//                 builder: (context) => UserProfilePage(
//                   username: user.username,
//                   email: user.email,
//                   profession: user.profession ??
//                       'Not provided', // Safe default for profession
//                 ),
//               );
//             }
//             return _errorRoute();
//           case '/eventDetails':
//             if (settings.arguments is Map<String, String>) {
//               final event = settings.arguments as Map<String, String>;
//               return MaterialPageRoute(
//                 builder: (context) => EventDetailsPage(event: event),
//               );
//             }
//             return _errorRoute();
//           default:
//             return _errorRoute();
//         }
//       },
//     );
//   }

//   // A fallback route for any unhandled or incorrect arguments
//   Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(
//       builder: (context) => Scaffold(
//         appBar: AppBar(title: const Text("Error")),
//         body: const Center(child: Text("Page not found or invalid arguments.")),
//       ),
//     );
//   }
// }


















































import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For token management
import 'screens/first_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/event_details_page.dart'; // Import event details page
import 'models/user.dart';
import 'utils/constants.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool hasToken = await _checkToken();
  runApp(MyApp(initialRoute: hasToken ? '/home' : '/'));
}

Future<bool> _checkToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('auth_token'); // Check if token exists
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: initialRoute, // Dynamic initial route
      routes: {
        '/': (context) => FirstPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
      },
      
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/profile':
            if (settings.arguments is User) {
              return MaterialPageRoute(
                builder: (context) => UserProfilePage(),
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

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found or invalid arguments.")),
      ),
    );
  }
}
