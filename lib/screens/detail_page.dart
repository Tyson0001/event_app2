import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String title = '';
  List<String> description = [];

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    final String response = await rootBundle.loadString('assets/details.json');
    final data = json.decode(response);

    setState(() {
      title = data['title'];
      description = List<String>.from(data['description']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('About'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: title.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ...description.map((paragraph) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          paragraph,
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
