import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';  // Import the permission_handler package

class AttendeesPage extends StatefulWidget {
  final String eventTitle;

  AttendeesPage({required this.eventTitle});

  @override
  _AttendeesPageState createState() => _AttendeesPageState();
}

class _AttendeesPageState extends State<AttendeesPage> {
  List<Map<String, dynamic>> attendees = [
    {'name': 'Alice', 'attended': false},
    {'name': 'Bob', 'attended': false},
    {'name': 'Charlie', 'attended': false},
  ];

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isProcessing) return;  // Prevent multiple scans at once
      setState(() {
        isProcessing = true;
      });
      _markAttendance(scanData.code);
    });
  }

  void _markAttendance(String? scannedName) {
    if (scannedName == null || scannedName.isEmpty) {
      // Show an error message if the QR code is invalid or empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid QR Code: Name is missing or empty")),
      );
      setState(() {
        isProcessing = false;
      });
      return;
    }

    // Check if scanned name matches any attendee's name
    bool found = false;
    for (var attendee in attendees) {
      if (attendee['name'].toLowerCase() == scannedName.toLowerCase()) {
        setState(() {
          attendee['attended'] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${attendee['name']} has been marked as attended!')),
        );
        found = true;
        break;
      }
    }

    // If the attendee is not found, add them to the list
    if (!found) {
      setState(() {
        attendees.add({'name': scannedName, 'attended': true});
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New attendee $scannedName added and marked as attended!')),
      );
    }

    // Set processing flag to false to allow further scanning
    setState(() {
      isProcessing = false;
    });
  }

  void _openQRScanner() async {
    // Request camera permission before opening the QR scanner
    PermissionStatus permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      showDialog(
        context: context,
        barrierDismissible: false,  // Prevent interaction with the UI outside the scanner
        builder: (context) => Dialog(
          child: Stack(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              if (isProcessing)
                Center(
                  child: CircularProgressIndicator(),  // Show a loading indicator while processing
                ),
            ],
          ),
        ),
      );
    } else {
      // Show a message if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission is required to scan QR codes")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventTitle} Attendees'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: _openQRScanner,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (context, index) {
          final attendee = attendees[index];
          return ListTile(
            title: Text(attendee['name']),
            trailing: Checkbox(
              value: attendee['attended'],
              onChanged: (bool? value) {
                setState(() {
                  attendee['attended'] = value!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
