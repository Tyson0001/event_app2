
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'project_detail_page.dart';

// class ProjectListPage extends StatefulWidget {
//   const ProjectListPage({Key? key}) : super(key: key);

//   @override
//   _ProjectListPageState createState() => _ProjectListPageState();
// }

// class _ProjectListPageState extends State<ProjectListPage> {
//   List<Map<String, dynamic>> projects = [];
//   Set<int> likedProjects = {}; // Stores the indexes of liked projects
//   Map<int, int> likeCounts = {}; // Stores the like count for each project
//   bool _isLoading = false;
//   String _errorMessage = '';

//   // URL to fetch projects from
//   static const String projectDataUrl =
//       'http://gatherhub-r7yr.onrender.com/user/conference/DP2024/groups/';

//   @override
//   void initState() {
//     super.initState();
//     _loadProjects();
//   }

//   Future<void> _loadProjects() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       // Try to load from SharedPreferences first
//       final prefs = await SharedPreferences.getInstance();
//       String? cachedProjectsJson = prefs.getString('cachedProjects');

//       if (cachedProjectsJson != null) {
//         // Load from cached data
//         final List<dynamic> data = json.decode(cachedProjectsJson);
//         _processProjectData(data);
//       } else {
//         // If no cached data, load from local assets
//         await _loadProjectsFromAssets();
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error loading project data: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }

//     // Load liked projects
//     await _loadLikedProjects();
//   }

//   Future<void> _loadProjectsFromAssets() async {
//     try {
//       String jsonString = await rootBundle.loadString('assets/project.json');
//       final List<dynamic> data = json.decode(jsonString);
//       _processProjectData(data);
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error loading project data from assets: $e';
//       });
//     }
//   }

//   Future<void> _fetchProjectsFromUrl() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     try {
//       final response = await http.get(Uri.parse(projectDataUrl));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);

//         // Cache the fetched data
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('cachedProjects', json.encode(data));

//         _processProjectData(data);
//       } else {
//         throw Exception('Failed to load projects from URL');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching projects: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _processProjectData(List<dynamic> data) {
//     setState(() {
//       projects = List<Map<String, dynamic>>.from(data);
//       likeCounts = {
//         for (int i = 0; i < projects.length; i++) i: 0
//       }; // Initialize like counts
//     });
//   }

//   Future<void> _loadLikedProjects() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       likedProjects =
//           prefs.getStringList('likedProjects')?.map(int.parse).toSet() ?? {};
//       // Update like counts based on saved likes
//       likedProjects.forEach((index) {
//         if (index < projects.length) {
//           likeCounts[index] = (likeCounts[index] ?? 0) + 1;
//         }
//       });
//     });
//   }

//   Future<void> _saveLikedProjects() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setStringList(
//         'likedProjects', likedProjects.map((e) => e.toString()).toList());
//   }

//   void _toggleLike(int projectIndex) {
//     setState(() {
//       if (likedProjects.contains(projectIndex)) {
//         likedProjects.remove(projectIndex); // Remove the like
//         likeCounts[projectIndex] = (likeCounts[projectIndex] ?? 1) - 1;
//       } else {
//         likedProjects.add(projectIndex); // Add the like
//         likeCounts[projectIndex] = (likeCounts[projectIndex] ?? 0) + 1;
//       }
//     });
//     _saveLikedProjects();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Projects'),
//         backgroundColor: Colors.red,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchProjectsFromUrl,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage.isNotEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         _errorMessage,
//                         style: const TextStyle(color: Colors.red),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: _loadProjects,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : projects.isEmpty
//                   ? const Center(child: Text('No projects found'))
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: projects.length,
//                       itemBuilder: (context, index) {
//                         final project = projects[index];
//                         final isLiked = likedProjects.contains(index);
//                         final likeCount = likeCounts[index] ?? 0;

//                         return Card(
//                           margin: const EdgeInsets.all(8.0),
//                           child: ListTile(
//                             title: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ProjectDetailPage(project: project),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 project['project_name'],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             subtitle: Text(
//                               'Group Number: ${project['Group_number']}',
//                               style: const TextStyle(
//                                 color: Colors.red,
//                               ),
//                             ),
//                             trailing: SizedBox(
//                               width: 100,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                       isLiked
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       color: isLiked ? Colors.red : Colors.grey,
//                                     ),
//                                     onPressed: () => _toggleLike(index),
//                                   ),
//                                   Text(
//                                     '$likeCount',
//                                     style: const TextStyle(
//                                         fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//     );
//   }
// }















































import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'project_detail_page.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  List<Map<String, dynamic>> projects = [];
  Set<int> likedProjects = {}; // Stores the indexes of liked projects
  Map<int, int> likeCounts = {}; // Stores the like count for each project
  bool _isLoading = false;
  String _errorMessage = '';

  // URL to fetch projects from
  static const String baseUrl = 'http://gatherhub-r7yr.onrender.com/user/conference/DP2024';
  static const String projectDataUrl = '$baseUrl/groups/';

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Try to load from SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      String? cachedProjectsJson = prefs.getString('cachedProjects');

      if (cachedProjectsJson != null) {
        // Load from cached data
        final List<dynamic> data = json.decode(cachedProjectsJson);
        _processProjectData(data);
      } else {
        // If no cached data, try to fetch from URL
        await _fetchProjectsFromUrl();
      }
    } catch (e) {
      // If URL fetch fails, load from local assets
      await _loadProjectsFromAssets();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    // Load liked projects
    await _loadLikedProjects();
  }

  Future<void> _loadProjectsFromAssets() async {
    try {
      String jsonString = await rootBundle.loadString('assets/project.json');
      final List<dynamic> data = json.decode(jsonString);
      _processProjectData(data);
    } catch (e) {
      _showErrorSnackBar('Error loading local project data');
    }
  }

  Future<void> _fetchProjectsFromUrl() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(projectDataUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Cache the fetched data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedProjects', json.encode(data));

        _processProjectData(data);
      } else {
        throw Exception('Failed to load projects. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error fetching projects: ${e.toString()}');
      
      // Fallback to local assets
      await _loadProjectsFromAssets();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _processProjectData(List<dynamic> data) {
    setState(() {
      projects = List<Map<String, dynamic>>.from(data);
      likeCounts = {
        for (int i = 0; i < projects.length; i++) 
          i: projects[i]['likes'] ?? 0
      };
    });
  }

  Future<void> _loadLikedProjects() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      likedProjects =
          prefs.getStringList('likedProjects')?.map(int.parse).toSet() ?? {};
      // Update like counts based on saved likes
      likedProjects.forEach((index) {
        if (index < projects.length) {
          likeCounts[index] = (likeCounts[index] ?? 0) + 1;
        }
      });
    });
  }

  Future<void> _saveLikedProjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'likedProjects', likedProjects.map((e) => e.toString()).toList());
  }

  Future<void> _toggleLike(int projectIndex) async {
    final project = projects[projectIndex];
    final groupNumber = project['Group_number'];

    // Prevent multiple simultaneous like actions
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentLikeStatus = likedProjects.contains(projectIndex);
      
      // Determine the appropriate API endpoint based on like/unlike action
      final url = currentLikeStatus 
          ? '$baseUrl/groups/$groupNumber/like-count-decrease'
          : '$baseUrl/groups/$groupNumber/like-count-increase';

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        // Parse the response to get the updated like count
        final responseBody = json.decode(response.body);
        final updatedLikeCount = responseBody['likeCount'] ?? 0;

        setState(() {
          if (currentLikeStatus) {
            likedProjects.remove(projectIndex);
          } else {
            likedProjects.add(projectIndex);
          }
          
          // Update like count from server response
          likeCounts[projectIndex] = updatedLikeCount;
        });
        
        // Save liked projects to local storage
        await _saveLikedProjects();

        // Show a success feedback
        _showSuccessSnackBar(currentLikeStatus ? 'Unliked' : 'Liked');
      } else {
        // Handle server error
        _showErrorSnackBar('Failed to update like status');
        
        // Revert local state
        setState(() {
          if (currentLikeStatus) {
            likedProjects.remove(projectIndex);
          } else {
            likedProjects.add(projectIndex);
          }
        });
      }
    } catch (e) {
      // Handle network or other errors
      _showErrorSnackBar('Error: ${e.toString()}');
      
      // Revert local state
      setState(() {
        if (likedProjects.contains(projectIndex)) {
          likedProjects.remove(projectIndex);
        } else {
          likedProjects.add(projectIndex);
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Utility method to show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Utility method to show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchProjectsFromUrl,
          ),
        ],
      ),
      body: _isLoading && projects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadProjects,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : projects.isEmpty
                  ? const Center(child: Text('No projects found'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        final isLiked = likedProjects.contains(index);
                        final likeCount = likeCounts[index] ?? 0;

                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectDetailPage(project: project),
                                  ),
                                );
                              },
                              child: Text(
                                project['project_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              'Group Number: ${project['Group_number']}',
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: _isLoading 
                                        ? null 
                                        : () => _toggleLike(index),
                                  ),
                                  Text(
                                    '$likeCount',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
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

// Custom exception for timeout
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
