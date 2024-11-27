

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Sponsor {
  final String name;
  final String photo;

  Sponsor({
    required this.name,
    required this.photo,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) {
    return Sponsor(
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'photo': photo,
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

  Future<void> loadStoredSponsors() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString('sponsors');
      if (storedData != null) {
        final List<dynamic> data = json.decode(storedData);
        loadSponsors(data);
      } else {
        // Automatically fetch new data if no local data exists
        await checkForNewData();
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load stored data: $e';
      });
      // Automatically fallback to fetching new data if loading stored data fails
      await checkForNewData();
    }
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
            'https://gatherhub-r7yr.onrender.com/user/conference/${widget.event['conferenceCode']}/eventCard/sponsors'),
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data successfully fetched and saved!')),
        );
      } else {
        throw HttpException(
            'Failed to load sponsors (Status: ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      // Retry loading stored data in case fetching fails
      await loadStoredSponsors();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadSponsors(List<dynamic> data) {
    setState(() {
      sponsors = data.map<Sponsor>((sponsor) => Sponsor.fromJson(sponsor)).toList();
    });
  }

  Widget _buildSponsorImage(String base64Image2) {
    try {
      String base64Image = base64Image2;
      if (base64Image.contains(',')) {
        base64Image = base64Image2.split(',')[1];
      }

      final imageBytes = base64Decode(base64Image);
      
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 40, color: Colors.grey);
        },
      );
    } catch (e) {
      print('Error loading sponsor image: $e');
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
                child: Text(
                  sponsor.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
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
            onTap: () => _showSponsorDetails(sponsor),
          ),
        );
      },
    );
  }
}
