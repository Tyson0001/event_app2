import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProjectDetailPage extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print("Project: $project");
    // Get list of image base64 strings
    List<String> imageStrings =
        List<String>.from(project['image']);

    return Scaffold(
      appBar: AppBar(
        title: Text(project['project_name']),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider for multiple images
            CarouselSlider.builder(
              itemCount: imageStrings.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                final imageBytes;
                try {
                  // imageBytes = base64Decode(imageStrings[index].split(',')[1]);
                  imageBytes = base64Decode(imageStrings[index]);
                } catch (e) {
                  return const Center(child: Text('Error loading image'));
                }

                return Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                );
              },
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
              ),
            ),
            const SizedBox(height: 16.0),

            // Project Title
            Text(
              project['project_name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Group Number
            Text(
              'Group Number: ${project['Group_number']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16.0),

            // Project Details
            Text(
              project['Description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Group Members
            const Text(
              'Group Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...project['members'].map<Widget>((member) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${member['name']} (Roll No: ${member['roll_no']}) - ${member['contribution']}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            const SizedBox(height: 16.0),

            // Faculty Members
            const Text(
              'Faculty Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...project['Faculty'].map<Widget>((faculty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  faculty,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
