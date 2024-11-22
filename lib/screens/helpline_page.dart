// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

// class HelplinePage extends StatefulWidget {
//   final Map<String, dynamic> event;

//   const HelplinePage({
//     Key? key,
//     required this.event,
//   }) : super(key: key);

//   @override
//   _HelplinePageState createState() => _HelplinePageState();
// }

// class _HelplinePageState extends State<HelplinePage> {
//   static const String _storageKey = 'helplines';
//   List<Map<String, String>> _helplines = [];
//   bool _isLoading = false;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadHelplinesFromStorage();
//   }

//   Future<void> _loadHelplinesFromStorage() async {
//     setState(() => _isLoading = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final helplinesData = prefs.getString(_storageKey);

//       if (helplinesData != null) {
//         final List<dynamic>? storedData = json.decode(helplinesData);
//         setState(() {
//           _helplines = _parseHelplines(storedData ?? []);
//           _isLoading = false;
//         });
//       } else {
//         await fetchHelplines();
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error loading helplines: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   List<Map<String, String>> _parseHelplines(List<dynamic> data) {
//     return data.map((item) => {
//       'name': item['name']?.toString() ?? 'Unknown',
//       'phone': item['phone']?.toString() ?? 'No number',
//     }).toList();
//   }

//   Future<void> fetchHelplines() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final url = Uri.parse(
//         'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/helplines'
//       );

//       final response = await http.get(url).timeout(
//         const Duration(seconds: 10),
//         onTimeout: () => throw TimeoutException('Request timed out'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         final fetchedHelplines = _parseHelplines(data);

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(_storageKey, json.encode(fetchedHelplines));

//         setState(() {
//           _helplines = fetchedHelplines;
//           _isLoading = false;
//         });
//       } else {
//         throw HttpException('Failed to load helplines (Error ${response.statusCode})');
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error fetching helplines: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     try {
//       if (await canLaunchUrl(phoneUri)) {
//         await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
//       } else {
//         _showErrorMessage('Could not launch $phoneNumber');
//       }
//     } catch (e) {
//       _showErrorMessage('Error: $e');
//     }
//   }

//   void _showErrorMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Emergency Helplines'),
//         backgroundColor: Colors.red,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchHelplines,
//             tooltip: 'Refresh helplines',
//           ),
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Loading helplines...'),
//           ],
//         ),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(_error!, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: fetchHelplines,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_helplines.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.phone_missed, size: 48, color: Colors.grey),
//             SizedBox(height: 16),
//             Text('No helplines available'),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: fetchHelplines,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(8.0),
//         itemCount: _helplines.length,
//         itemBuilder: (context, index) {
//           final helpline = _helplines[index];
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.symmetric(vertical: 4.0),
//             child: ListTile(
//               leading: const Icon(Icons.local_hospital, color: Colors.red),
//               title: Text(
//                 helpline['name']!,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(helpline['phone']!),
//               trailing: IconButton(
//                 icon: const Icon(Icons.phone, color: Colors.green),
//                 onPressed: () => _makePhoneCall(helpline['phone']!),
//                 tooltip: 'Call ${helpline['name']}',
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }






















































import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HelplinePage extends StatefulWidget {
  final Map<String, dynamic> event;

  const HelplinePage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  _HelplinePageState createState() => _HelplinePageState();
}

class _HelplinePageState extends State<HelplinePage> {
  static const String _storageKey = 'helplines';
  List<Map<String, String>> _helplines = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHelplinesFromStorage();
  }

  Future<void> _loadHelplinesFromStorage() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final helplinesData = prefs.getString(_storageKey);

      if (helplinesData != null) {
        final List<dynamic>? storedData = json.decode(helplinesData);
        setState(() {
          _helplines = _parseHelplines(storedData ?? []);
          _isLoading = false;
        });
      } else {
        await fetchHelplines();
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading helplines: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, String>> _parseHelplines(List<dynamic> data) {
    return data.map((item) => {
      'name': item['name']?.toString() ?? 'Unknown',
      'phone': item['phone']?.toString() ?? 'No number',
    }).toList();
  }

  Future<void> fetchHelplines() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url = Uri.parse(
        'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/helplines'
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final fetchedHelplines = _parseHelplines(data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, json.encode(fetchedHelplines));

        setState(() {
          _helplines = fetchedHelplines;
          _isLoading = false;
        });
      } else {
        throw HttpException('Failed to load helplines (Error ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching helplines: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await launchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorMessage( 'Could not launch $phoneNumber');
      }
    } catch (e) {
      _showErrorMessage( 'Error: $e');
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Helplines'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchHelplines,
            tooltip: 'Refresh helplines',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }



  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading helplines...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: fetchHelplines,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_helplines.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_missed, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No helplines available'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchHelplines,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _helplines.length,
        itemBuilder: (context, index) {
          final helpline = _helplines[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red),
              title: Text(
                helpline['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(helpline['phone']!),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => _makePhoneCall(helpline['phone']!),
                tooltip: 'Call ${helpline['name']}',
              ),
            ),
          );
        },
      ),
    );
  }
}
