// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class DetailPage extends StatefulWidget {

//   const DetailPage({Key? key, required this.event}) : super(key: key);

//   final Map<String, String> event;
//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   String title = '';
//   List<String> description = [];

//   @override
//   void initState() {
//     super.initState();
//     loadDetails();
//   }

//   Future<void> loadDetails() async {
//     final String response = await rootBundle.loadString('assets/details.json');
//     final data = json.decode(response);

//     setState(() {
//       title = data['title'];
//       description = List<String>.from(data['description']);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text('About'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: title.isNotEmpty
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   ...description.map((paragraph) => Padding(
//                         padding: const EdgeInsets.only(bottom: 16.0),
//                         child: Text(
//                           paragraph,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       )),
//                 ],
//               )
//             : Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }


























// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class DetailPage extends StatefulWidget {
//   final Map<String, dynamic> event;

//   DetailPage({required this.event});

//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   String title = '';
//   String description = '';
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     loadDetailsFromStorage();
//   }

//   Future<void> loadDetailsFromStorage() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? storedData = prefs.getString('details_stored');

//       // Load from local storage
//       final data = json.decode(storedData!);
//       setState(() {
//         title = data['title'] ?? '';
//         description = data['description'] ?? '';
//         isLoading = false;
//       });
//         } catch (e) {
//       setState(() {
//         error = 'Error loading details from storage: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchDetails() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     try {
//       final response = await http.get(Uri.parse(
//           'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/about'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('details_stored', json.encode(data));

//         setState(() {
//           title = data['title'] ?? '';
//           description = data['description'] ?? '';
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           error = 'Failed to load details. Status code: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error fetching details: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text('About'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchDetails,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : error != null
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(error!, style: const TextStyle(color: Colors.red)),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: fetchDetails,
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         description,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }
// }





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  DetailPage({required this.event});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String title = '';
  String description = '';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDetailsFromStorage();
  }

  Future<void> loadDetailsFromStorage() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedData = prefs.getString('details_stored');

      if (storedData != null) {
        // Load from local storage
        final data = json.decode(storedData);
        setState(() {
          title = data['title'] ?? '';
          description = data['description'] ?? '';
          isLoading = false;
        });
      } else {
        // If not found locally, fetch from the URL
        await fetchDetails();
      }
    } catch (e) {
      setState(() {
        error = 'Error loading details from storage: $e';
        isLoading = false;
      });
      // Fetch details as a fallback
      await fetchDetails();
    }
  }

  Future<void> fetchDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/about'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('details_stored', json.encode(data));

        setState(() {
          title = data['title'] ?? '';
          description = data['description'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load details. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching details: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchDetails,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
      ),
    );
  }
}

