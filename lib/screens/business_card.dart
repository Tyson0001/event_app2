// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class BusinessCardPage extends StatefulWidget {
//   const BusinessCardPage({super.key});

//   @override
//   _BusinessCardPageState createState() => _BusinessCardPageState();
// }

// class _BusinessCardPageState extends State<BusinessCardPage> {
//   List<dynamic>? businessCards;

//   @override
//   void initState() {
//     super.initState();
//     loadBusinessCards();
//   }

//   Future<void> loadBusinessCards() async {
//     final String response =
//         await rootBundle.loadString('assets/business_card.json');
//     final List<dynamic> data = json.decode(response);
//     setState(() {
//       businessCards = data;
//     });
//   }



//   void _showErrorMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Business Cards"),
//       ),
//       body: businessCards == null
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: businessCards!.length,
//               itemBuilder: (context, index) {
//                 final card = businessCards![index];
//                 return Card(
//                   margin: const EdgeInsets.all(8.0),
//                   elevation: 4.0,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           card['name'],
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
                    
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             const Icon(Icons.email, color: Colors.red),
//                             const SizedBox(width: 8),
//                             Text(card['email']),
//                           ],
//                         ),
                       
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }






























import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Add this package to pubspec.yaml

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage({super.key});

  @override
  BusinessCardPageState createState() => BusinessCardPageState();
}

class BusinessCardPageState extends State<BusinessCardPage> {
  String? username;
  List<dynamic>? businessCards;
  late String dataUrl;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getUsernameFromToken();
    if (username != null) {
      dataUrl = "https://gatherhub-r7yr.onrender.com/user/getFriends/$username/";
      await loadBusinessCards();
    }
  }

  Future<void> getUsernameFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      
      if (token == null) {
        _showErrorMessage(context, "No token found. Please login again.");
        // Navigate to login page here if needed
        return;
      }

      // Decode the JWT token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      
      // Assuming the username is stored in the 'username' claim of the token
      // Adjust this based on your actual token structure
      setState(() {
        username = decodedToken['username'] ?? decodedToken['sub'];
      });
    } catch (e) {
      _showErrorMessage(context, "Error decoding token: $e");
    }
  }

  Future<void> loadBusinessCards() async {
    if (username == null) {
      _showErrorMessage(context, "Username not available. Please login again.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('businessCards');
    
    if (savedData != null) {
      setState(() {
        businessCards = json.decode(savedData);
      });
    } else {
      await fetchFromUrlAndSave();
    }
  }

  Future<void> fetchFromUrlAndSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      
      if (token == null) {
        _showErrorMessage(context, "No token found. Please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse(dataUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        await prefs.setString('businessCards', json.encode(data));
        setState(() {
          businessCards = data;
        });
      } else if (response.statusCode == 401) {
        _showErrorMessage(context, "Token expired. Please login again.");
        // Navigate to login page here if needed
      } else {
        _showErrorMessage(context, "Failed to load data from the URL.");
      }
    } catch (e) {
      _showErrorMessage(context, "Error loading data: $e");
    }
  }

  Future<void> reloadBusinessCards() async {
    await fetchFromUrlAndSave();
    _showErrorMessage(context, "Data reloaded from URL.");
  }

  void _showErrorMessage(BuildContext context, String message) {
    if (mounted) {  // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username != null ? "Cards for $username" : "Business Cards"), 
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reloadBusinessCards,
          ),
        ],
      ),
      body: businessCards == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: businessCards!.length,
              itemBuilder: (context, index) {
                final card = businessCards![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card['name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(card['email']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}