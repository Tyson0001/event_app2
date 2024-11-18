// import 'package:flutter/material.dart';

// class SponsorsPage extends StatelessWidget {
//   final List<Map<String, String>> sponsors = [
//     {
//       'name': 'TechCorp',
//       'logo': 'assets/images/event1.jpg',
//     },
//     {
//       'name': 'Innovate Inc.',
//       'logo': 'assets/images/event2.jpg',
//     },
//     {
//       'name': 'Creative Studios',
//       'logo': 'assets/images/event3.jpg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sponsors'),
//       ),
//       body: ListView.builder(
//         itemCount: sponsors.length,
//         itemBuilder: (context, index) {
//           final sponsor = sponsors[index];
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
//                               sponsor['logo']!,
//                               fit: BoxFit.cover,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 sponsor['name']!,
//                                 style: TextStyle(
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
//                 child: Image.asset(
//                   sponsor['logo']!,
//                   width: 50,
//                   height: 50,
//                 ),
//               ),
//               title: Text(
//                 sponsor['name']!,
//                 style: TextStyle(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
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

class Sponsor {
  final String name;
  final String photo;
  final String profession;

  Sponsor({
    required this.name,
    required this.photo,
    required this.profession,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) {
    return Sponsor(
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

class SponsorPage extends StatefulWidget {
  const SponsorPage({Key? key, required this.event}) : super(key: key);

  final Map<String, String> event;

  @override
  State<SponsorPage> createState() => _SponsorPageState();
}

class _SponsorPageState extends State<SponsorPage> {
  List<Sponsor> sponsors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadStoredSponsors();
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
            'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['eventCode']}/eventCard/sponsors'),
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
        await prefs.setString('sponsors', json.encode(data));
        loadSponsors(data);
      } else {
        throw HttpException(
            'Failed to load sponsors (Status: ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      await loadStoredSponsors();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadStoredSponsors() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString('sponsors');
      if (storedData != null) {
        final List<dynamic> data = json.decode(storedData);
        loadSponsors(data);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load stored data: $e';
      });
    }
  }

  void loadSponsors(List<dynamic> data) {
    setState(() {
      sponsors = data.map<Sponsor>((sponsor) => Sponsor.fromJson(sponsor)).toList();
    });
  }

  Widget _buildSponsorImage(String base64Image) {
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

  void _showSponsorDetails(Sponsor sponsor) {
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
                  child: _buildSponsorImage(sponsor.photo),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      sponsor.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sponsor.profession,
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
        title: const Text('Sponsors'), 
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
    if (isLoading && sponsors.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sponsors.isEmpty && errorMessage.isNotEmpty) {
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

    if (sponsors.isEmpty) {
      return const Center(
        child: Text('No sponsors available'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sponsors.length,
      itemBuilder: (context, index) {
        final sponsor = sponsors[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Hero(
              tag: 'sponsor-${sponsor.name}',
              child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: _buildSponsorImage(sponsor.photo),
                ),
              ),
            ),
            title: Text(
              sponsor.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              sponsor.profession,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () => _showSponsorDetails(sponsor),
          ),
        );
      },
    );
  }
}
