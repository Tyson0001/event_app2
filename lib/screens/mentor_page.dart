// import 'package:flutter/material.dart';

// class MentorPage extends StatelessWidget {
//   final List<Map<String, String>> mentors = [
//     {
//       'name': 'Dr. Emily Brown',
//       'photo': 'assets/images/event1.jpg',
//       'profession': 'Senior AI Researcher at DataLabs'
//     },
//     {
//       'name': 'Mr. James Wilson',
//       'photo': 'assets/images/event2.jpg',
//       'profession': 'Tech Lead at FutureTech'
//     },
//     {
//       'name': 'Ms. Sarah Lee',
//       'photo': 'assets/images/event3.jpg',
//       'profession': 'UX Strategist at DesignWorks'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mentors'),
//       ),
//       body: ListView.builder(
//         itemCount: mentors.length,
//         itemBuilder: (context, index) {
//           final mentor = mentors[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               leading: InkWell(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Dialog(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Image.asset(
//                               mentor['photo']!,
//                               fit: BoxFit.cover,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 mentor['name']!,
//                                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: CircleAvatar(
//                   backgroundImage: AssetImage(mentor['photo']!),
//                   radius: 30,
//                 ),
//               ),
//               title: Text(
//                 mentor['name']!,
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               subtitle: Text(
//                 mentor['profession']!,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

















import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Mentor {
  final String name;
  final String photo;
  final String profession;

  Mentor({
    required this.name,
    required this.photo,
    required this.profession,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      profession: json['profession'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'photo': photo,
        'profession': profession,
      };
}

class MentorPage extends StatefulWidget {
  const MentorPage({Key? key, required this.event}) : super(key: key);

  final Map<String, String> event;

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  List<Mentor> mentors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadStoredMentors();
  }

  Future<void> checkForNewData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http
          .get(
        Uri.parse(
            'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['eventCode']}/eventCard/mentors'),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
              'Connection timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mentors', json.encode(data));
        loadMentors(data);
      } else {
        throw HttpException(
            'Failed to load mentors (Status: ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      await loadStoredMentors();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadStoredMentors() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString('mentors');
      if (storedData != null) {
        final List<dynamic> data = json.decode(storedData);
        loadMentors(data);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load stored data: $e';
      });
    }
  }

  void loadMentors(List<dynamic> data) {
    setState(() {
      mentors = data.map<Mentor>((mentor) => Mentor.fromJson(mentor)).toList();
    });
  }

  Widget _buildMentorImage(String base64Image) {
    try {
      final imageBytes = base64Decode(base64Image);
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 40, color: Colors.grey);
        },
      );
    } catch (e) {
      return const Icon(Icons.person, size: 40, color: Colors.grey);
    }
  }

  void _showMentorDetails(Mentor mentor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildMentorImage(mentor.photo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      mentor.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mentor.profession,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: checkForNewData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: checkForNewData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && mentors.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mentors.isEmpty && errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: checkForNewData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (mentors.isEmpty) {
      return const Center(
        child: Text('No mentors available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mentors.length,
      itemBuilder: (context, index) {
        final mentor = mentors[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Hero(
              tag: 'mentor-${mentor.name}',
              child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: _buildMentorImage(mentor.photo),
                ),
              ),
            ),
            title: Text(
              mentor.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              mentor.profession,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () => _showMentorDetails(mentor),
          ),
        );
      },
    );
  }
}
