// import 'package:GatherHub/screens/business_card.dart';
// import 'package:GatherHub/screens/qr_scanner.dart';
// import 'package:flutter/material.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';

// class UserProfilePage extends StatefulWidget {
//   final String username;
//   final String email;
//   final String profession;

//   const UserProfilePage({
//     super.key,
//     required this.username,
//     required this.email,
//     required this.profession,
//   });

//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner())); // Navigate to scan page
//             },
//             icon: const Icon(Icons.qr_code_scanner),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessCardPage())); // Navigate to business_card.dart page
//             },
//             icon: const Icon(Icons.card_membership), // Use a valid icon
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               widget.username.toUpperCase(),
//               style: const TextStyle(
//                 fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
//             ),
//             const SizedBox(height: 10),
//             PrettyQr(
//               data:
//                   'Username: ${widget.username}\nEmail: ${widget.email}\nProfession: ${widget.profession}',
//               size: 200,
//               roundEdges: true,
//               elementColor: Colors.blue,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }





















































import 'package:GatherHub/screens/business_card.dart';
import 'package:GatherHub/screens/qr_scanner_cardSHaring.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _username = 'Loading...';
  String _linkedInUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final jwt = JWT.decode(token);

    setState(() {
      // _linkedInUrl = prefs.getString('linkedInUrl') ?? '';
      // _name = prefs.getString('name') ??
      //     prefs.getString('username') ??
      //     'Unknown User';
      // _email = prefs.getString('email') ?? 'No Email';

      _linkedInUrl = jwt.payload['linkedIn'] ?? '';
      _name = jwt.payload['name'] ?? 'Unknown User';
      _email = jwt.payload['email'] ?? 'No Email';
      _username = jwt.payload['username'] ?? 'No Username';
      // _email = prefs.getString('email') ?? 'No Email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text('User Profile'), 
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner())); // Navigate to scan page
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessCardPage())); // Navigate to business_card.dart page
            },
            icon: const Icon(Icons.card_membership), // Use a valid icon
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Center vertically within available space
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: [
              Text(
                _name.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Dynamically adapt text color
                ),
                textAlign: TextAlign.center, // Center the text content
              ),
              const SizedBox(height: 20),
              PrettyQr(
                data: _username,
                size: 200,
                roundEdges: true,
                elementColor: Colors.blue, // Set QR elements to blue
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
