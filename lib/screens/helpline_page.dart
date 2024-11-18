// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HelplinePage extends StatelessWidget {
//   final List<Map<String, String>> helplines = [
//     {
//       'name': 'Event Support',
//       'phone': '+1234567890',
//     },
//     {
//       'name': 'Tech Assistance',
//       'phone': '+0987654321',
//     },
//     {
//       'name': 'Emergency Contact',
//       'phone': '+1122334455',
//     },
//   ];

//   void _makePhoneCall(String phoneNumber, BuildContext context) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     try {
//       if (await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
//         // Successfully launched phone dialer
//       } else {
//         _showErrorMessage(context, 'Could not launch $phoneNumber');
//       }
//     } catch (e) {
//       _showErrorMessage(context, 'Error: $e');
//     }
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
//         title: Text('Helpline'),
//       ),
//       body: ListView.builder(
//         itemCount: helplines.length,
//         itemBuilder: (context, index) {
//           final helpline = helplines[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               title: Text(helpline['name']!),
//               subtitle: Text(helpline['phone']!),
//               trailing: IconButton(
//                 icon: Icon(Icons.phone),
//                 onPressed: () => _makePhoneCall(helpline['phone']!, context),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HelplinePage extends StatefulWidget {
  final Map<String, dynamic> event;

  HelplinePage({required this.event});

  @override
  _HelplinePageState createState() => _HelplinePageState();
}

class _HelplinePageState extends State<HelplinePage> {
  List<Map<String, String>> helplines = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadHelplinesFromStorage();
  }

  Future<void> loadHelplinesFromStorage() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? helplinesData = prefs.getString('helplines');
      List<dynamic> storedData = json.decode(helplinesData!);
      setState(() {
        helplines = storedData
            .map((item) => {
                  'name': item['name'].toString(),
                  'phone': item['phone'].toString(),
                })
            .toList();
        isLoading = false;
      });
        } catch (e) {
      setState(() {
        error = 'Error loading helplines: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchHelplines() async {
    setState(() {
      isLoading = true;
      error = null;
    });

// helplines
    try {
      // Replace this URL with your actual API endpoint
      final response = await http.get(Uri.parse('https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/helplines'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> fetchedHelplines = data
            .map((item) => {
                  'name': item['name'].toString(),
                  'phone': item['phone'].toString(),
                })
            .toList();

        //     ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Helplines loaded successfully ${data}')),
        // );

        

        // Save to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('helplines', json.encode(fetchedHelplines));

        setState(() {
          helplines = fetchedHelplines;
          isLoading = false;
        });
      } else {
        setState(() {
          error =
              'Failed to load helplines. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching helplines: $e';
        isLoading = false;
      });
    }
  }

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
        // Successfully launched phone dialer
      } else {
        _showErrorMessage(context, 'Could not launch $phoneNumber');
      }
    } catch (e) {
      _showErrorMessage(context, 'Error: $e');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helpline'), 
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchHelplines,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchHelplines,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (helplines.isEmpty) {
      return Center(child: Text('No helplines available'));
    }

    return ListView.builder(
      itemCount: helplines.length,
      itemBuilder: (context, index) {
        final helpline = helplines[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(helpline['name']!),
            subtitle: Text(helpline['phone']!),
            trailing: IconButton(
              icon: Icon(Icons.phone),
              onPressed: () => _makePhoneCall(helpline['phone']!, context),
            ),
          ),
        );
      },
    );
  }
}
