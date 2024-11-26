import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'project_detail_page.dart'; // Import the new page

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  List<Map<String, dynamic>> projects = [];
  Set<int> likedProjects = {}; // Stores the indexes of liked projects
  Map<int, int> likeCounts = {}; // Stores the like count for each project

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _loadLikedProjects();
  }

  Future<void> _loadProjects() async {
    try {
      String jsonString = await rootBundle.loadString('assets/project.json');
      final List<dynamic> data = json.decode(jsonString);
      setState(() {
        projects = List<Map<String, dynamic>>.from(data);
        likeCounts = {for (int i = 0; i < projects.length; i++) i: 0}; // Initialize like counts
      });
    } catch (e) {
      print('Error loading project data: $e');
    }
  }

  Future<void> _loadLikedProjects() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      likedProjects = prefs.getStringList('likedProjects')?.map(int.parse).toSet() ?? {};
      // Update like counts based on saved likes
      likedProjects.forEach((index) {
        likeCounts[index] = (likeCounts[index] ?? 0) + 1;
      });
    });
  }

  Future<void> _saveLikedProjects() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('likedProjects', likedProjects.map((e) => e.toString()).toList());
  }

  void _toggleLike(int projectIndex) {
    setState(() {
      if (likedProjects.contains(projectIndex)) {
        likedProjects.remove(projectIndex); // Remove the like
        likeCounts[projectIndex] = (likeCounts[projectIndex] ?? 1) - 1;
      } else {
        likedProjects.add(projectIndex); // Add the like
        likeCounts[projectIndex] = (likeCounts[projectIndex] ?? 0) + 1;
      }
    });
    _saveLikedProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent overflow when keyboard appears
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: Colors.red,
      ),
      body: projects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true, // Shrinks the list to only take up the required space
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                final isLiked = likedProjects.contains(index);
                final likeCount = likeCounts[index] ?? 0;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    // Project Name (clickable)
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailPage(project: project),
                          ),
                        );
                      },
                      child: Text(
                        project['projectTitle'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Bold text for title
                        ),
                      ),
                    ),

                    // Group Number
                    subtitle: Text(
                      'Group Number: ${project['groupNumber']}',
                      style: const TextStyle(
                        color: Colors.red, // Red color for group number
                      ),
                    ),

                    // Like Button and Counter (Horizontal Layout)
                    trailing: SizedBox(
                      width: 100, // Increased width to accommodate both like button and counter
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Aligns everything to the right
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleLike(index),
                          ),
                          Text(
                            '$likeCount', // Just the like count (without 'Likes' text for more compact display)
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
