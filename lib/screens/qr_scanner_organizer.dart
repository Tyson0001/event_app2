import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'first_page.dart';

class QrScannerOrganizer extends StatefulWidget {
  const QrScannerOrganizer({super.key});

  @override
  State<QrScannerOrganizer> createState() => _QrScannerOrganizerState();
}

class _QrScannerOrganizerState extends State<QrScannerOrganizer> {
  MobileScannerController? _controller;
  final TextEditingController _eventCodeController = TextEditingController();
  final TextEditingController _subEventCodeController = TextEditingController();
  bool _isFlashOn = false;
  String? _secondUsername;
  bool _hasPermission = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitialize();
    // _loadUsernameFromToken();
  }

  Future<void> _checkPermissionAndInitialize() async {
    final status = await Permission.camera.status;

    if (!status.isGranted) {
      await Permission.camera.request();
    }

    if (await Permission.camera.isGranted) {
      setState(() {
        _hasPermission = true;
        _initializeScanner();
      });
    } else {
      setState(() {
        _errorMessage = 'Camera permission denied. Enable it from settings.';
      });
    }
  }

  void _initializeScanner() {
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: _isFlashOn,
    );
  }

  Future<void> _loadUsernameFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token != null && !JwtDecoder.isExpired(token)) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        setState(() {
          _secondUsername = decodedToken['username'];
        });
      } else {
        _showResult(context, 'Invalid or expired token. Please log in again.');
      }
    } catch (e) {
      _showResult(context, 'Error loading user data: $e');
    }
  }

  Future<void> _handleScannedCode(String code) async {
    if (_subEventCodeController.text == "0") {
      // Handle streamlit URL case
      try {
        final Uri url = Uri.parse(code);
        print("URL: $url");
        String? email = url.queryParameters['email'];
        String? conferenceCode = url.queryParameters['confcode'];
        String? eventCode = "0";
        print("Email: $email");
        print(" Code: $conferenceCode");

        if (email != null && conferenceCode != null) {
          await _moveAttendee(email, conferenceCode, eventCode);
        } else {
          _showResult(
              context, 'Invalid URL format: missing email or conference code');
        }
      } catch (e) {
        _showResult(context, 'Invalid URL format: $e');
      }
    } else {
      // Handle event attendance case
      try {
        final Uri url = Uri.parse(code);
        String? email = url.queryParameters['email'];

        if (email != null) {
          await _addAttendeeToEvent(
            email,
            _eventCodeController.text,
            _subEventCodeController.text,
          );
        } else {
          _showResult(context, 'Invalid QR code: missing email');
        }
      } catch (e) {
        _showResult(context, 'Invalid QR code format: $e');
      }
    }
  }

  Future<void> _moveAttendee(
      String email, String conferenceCode, String eventCode) async {
    final String baseUrl = 'https://gatherhub-r7yr.onrender.com';
    final String url = '$baseUrl/user/conference/$conferenceCode/eventCard/move-attendee';
    
    print("url2: $url");
    final requestBody = jsonEncode({
      // 'conferenceCode': conferenceCode,
      // 'eventCode': eventCode,
      'username': email, // Using email as username for this case
    });
    print("Request body: $requestBody");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      // print("Response: $response");
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _showResult(context, 'Success: ${result['message']}');
      } else {
        final error = jsonDecode(response.body);
        _showResult(
            context, 'Error: ${error['error'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      _showResult(context, 'Error moving attendee: $e');
    }
  }

  Future<void> _addAttendeeToEvent(
      String email, String conferenceCode, String eventCode) async {
    final String baseUrl = 'https://gatherhub-r7yr.onrender.com';
    final String url =
        '$baseUrl/user/conference/$conferenceCode/add-attendee-for-event';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // 'conferenceCode': conferenceCode,
          // 'eventCode': eventCode,
          'username': email
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _showResult(context,
            'Success: Attendee added to event\nConference: ${result['conferenceName']}\nEvent: $eventCode');
      } else {
        final error = jsonDecode(response.body);
        _showResult(
            context, 'Error: ${error['error'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      _showResult(context, 'Error adding attendee to event: $e');
    }
  }

  void _showResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scanner Result'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _controller?.start(); // Resume scanning
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner Organizer'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          if (_hasPermission && _controller != null)
            IconButton(
              icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
              onPressed: () {
                setState(() {
                  _isFlashOn = !_isFlashOn;
                });
                _controller?.toggleTorch();
              },
            ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FirstPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _eventCodeController,
                decoration: const InputDecoration(
                  labelText: 'Enter Conference Code',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _subEventCodeController,
                decoration: const InputDecoration(
                  labelText: 'Enter Sub-Event Code (0 for attendance marking)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (_hasPermission && _controller != null)
              Container(
                height: 300,
                child: MobileScanner(
                  controller: _controller!,
                  errorBuilder: (context, error, child) {
                    return Center(
                      child: Text(
                        'Error initializing camera: ${error.errorCode}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  },
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final String? code = barcodes.first.rawValue;

                      if (code != null &&
                          _eventCodeController.text.isNotEmpty) {
                        _controller?.stop();
                        _handleScannedCode(code);
                      } else if (_eventCodeController.text.isEmpty) {
                        _showResult(context, 'Please enter a conference code.');
                      }
                    }
                  },
                ),
              )
            else
              Center(
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
                      onPressed: _checkPermissionAndInitialize,
                      child: const Text('Request Camera Permission'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _eventCodeController.dispose();
    _subEventCodeController.dispose();
    super.dispose();
  }
}



















// WORKING CODE
// ----------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:http/http.dart' as http;
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:permission_handler/permission_handler.dart';

// import 'first_page.dart';

// /// QR Scanner widget for organizers to scan and process attendee QR codes
// class QrScannerOrganizer extends StatefulWidget {
//   const QrScannerOrganizer({super.key});

//   @override
//   State<QrScannerOrganizer> createState() => _QrScannerOrganizerState();
// }

// class _QrScannerOrganizerState extends State<QrScannerOrganizer> {
//   // Controllers
//   MobileScannerController? _controller;
//   final TextEditingController _eventCodeController = TextEditingController();

//   // State variables
//   bool _isFlashOn = false;
//   String? secondUsername;
//   bool _hasPermission = false;
//   String _errorMessage = '';

//   // API endpoints
//   static const String _baseUrl = 'https://gatherhub-r7yr.onrender.com';
//   static const String _visitingCardEndpoint = '/eventCard/move-attendee';
//   static const String _regularEndpoint = '/move-attendee';

//   // ================ Lifecycle Methods ================

//   @override
//   void initState() {
//     super.initState();
//     _initializeScanner();
//     _loadUsernameFromToken();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     _eventCodeController.dispose();
//     super.dispose();
//   }

//   // ================ URL Processing Methods ================

//   /// Extracts email from visiting card URL
//   String? _extractEmailFromUrl(String code) {
//     try {
//       final uri = Uri.parse(code);
//       if (uri.host == 'niweshvistingcard.streamlit.app') {
//         return uri.queryParameters['email'];
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Checks if URL is from visiting card website
//   bool _isVisitingCardUrl(String code) {
//     try {
//       final uri = Uri.parse(code);
//       return uri.host == 'niweshvistingcard.streamlit.app';
//     } catch (e) {
//       return false;
//     }
//   }

//   // ================ Initialization Methods ================

//   /// Initialize camera scanner and request permissions
//   Future<void> _initializeScanner() async {
//     final status = await Permission.camera.request();
    
//     setState(() {
//       _hasPermission = status.isGranted;
//       if (_hasPermission) {
//         _controller = MobileScannerController(
//           facing: CameraFacing.back,
//           torchEnabled: _isFlashOn,
//         );
//         _errorMessage = '';
//       } else {
//         _errorMessage = 'Camera permission is required to use the scanner';
//       }
//     });
//   }

//   /// Load username from stored JWT token
//   Future<void> _loadUsernameFromToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('auth_token');

//       if (token != null && !JwtDecoder.isExpired(token)) {
//         Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
//         setState(() {
//           secondUsername = decodedToken['username'];
//         });
//       } else {
//         _showResult('Invalid or expired token. Please log in again.');
//       }
//     } catch (e) {
//       _showResult('Error loading user data: $e');
//     }
//   }

//   // ================ QR Code Processing Methods ================

//   /// Process scanned QR code and determine appropriate action
//   Future<void> _processQrCode(String code) async {
//     if (_eventCodeController.text.isEmpty) {
//       _showResult('Please enter an event code.');
//       return;
//     }

//     String? email = _extractEmailFromUrl(code);
    
//     if (_isVisitingCardUrl(code)) {
//       if (email != null) {
//         await _fetchFromServerForVisitingCard(email, _eventCodeController.text);
//       } else {
//         _showResult('Invalid visiting card QR code: No email found');
//       }
//     } else {
//       await _fetchFromServer(code, _eventCodeController.text);
//     }
//   }

//   // ================ API Communication Methods ================

//   /// Handle visiting card API requests
//   Future<void> _fetchFromServerForVisitingCard(String email, String eventCode) async {
//     final url = Uri.parse('$_baseUrl/user/conference/$eventCode$_visitingCardEndpoint');

//     try {
//       final response = await http.put(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': email}),
//       );

//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         _showResult('Success: ${result['message']}');
//       } else {
//         _showResult('Error: Status ${response.statusCode}\nBody: ${response.body}');
//       }
//     } catch (e) {
//       _showResult('Network Error: $e');
//     }
//   }

//   /// Handle regular QR code API requests
//   Future<void> _fetchFromServer(String code, String eventCode) async {
//     final url = Uri.parse('$_baseUrl/user/conference/$eventCode$_regularEndpoint');

//     try {
//       final response = await http.put(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'username': code}),
//       );

//       if (response.statusCode == 200) {
//         final result = jsonDecode(response.body);
//         _showResult('Success: ${result['message']}');
//       } else {
//         _showResult('Error: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       _showResult('Network Error: $e');
//     }
//   }

//   // ================ UI Methods ================

//   /// Show result dialog to user
//   void _showResult(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Server Response'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _controller?.start(); // Resume scanning
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//     );
//   }

//   // ================ Widget Building Methods ================

//   /// Build app bar with actions
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       title: const Text('QR Scanner Organizer'),
//       backgroundColor: Colors.red,
//       centerTitle: true,
//       actions: [
//         if (_hasPermission && _controller != null)
//           IconButton(
//             icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
//             onPressed: _toggleFlash,
//           ),
//         IconButton(
//           icon: const Icon(Icons.home),
//           onPressed: _navigateToHome,
//         ),
//       ],
//     );
//   }

//   /// Build main body of the screen
//   Widget _buildBody() {
//     return Stack(
//       children: [
//         _buildScanner(),
//         _buildBottomControls(),
//       ],
//     );
//   }

//   /// Build scanner widget or permission request
//   Widget _buildScanner() {
//     if (!_hasPermission || _controller == null) {
//       return _buildPermissionRequest();
//     }

//     return MobileScanner(
//       controller: _controller!,
//       errorBuilder: (context, error, child) => _buildScannerError(error),
//       onDetect: _handleScannerDetection,
//     );
//   }

//   /// Build permission request widget
//   Widget _buildPermissionRequest() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             _errorMessage,
//             style: const TextStyle(color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _initializeScanner,
//             child: const Text('Request Camera Permission'),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build scanner error widget
//   Widget _buildScannerError(MobileScannerException error) {
//     return Center(
//       child: Text(
//         'Error initializing camera: ${error.errorCode}',
//         style: const TextStyle(color: Colors.red),
//       ),
//     );
//   }

//   /// Build bottom controls (event code input)
//   Widget _buildBottomControls() {
//     return Positioned(
//       bottom: 20,
//       left: 20,
//       right: 20,
//       child: Column(
//         children: [
//           TextField(
//             controller: _eventCodeController,
//             decoration: const InputDecoration(
//               labelText: 'Enter Event Code',
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () => setState(() {}),
//             child: const Text('Set Event Code'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ================ Helper Methods ================

//   /// Toggle flash state
//   void _toggleFlash() {
//     setState(() {
//       _isFlashOn = !_isFlashOn;
//     });
//     _controller?.toggleTorch();
//   }

//   /// Navigate to home screen
//   void _navigateToHome() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const FirstPage()),
//     );
//   }

//   /// Handle QR code detection
//   void _handleScannerDetection(BarcodeCapture capture) {
//     final List<Barcode> barcodes = capture.barcodes;
//     if (barcodes.isNotEmpty) {
//       final String? code = barcodes.first.rawValue;
//       if (code != null) {
//         _controller?.stop();
//         _processQrCode(code);
//       }
//     }
//   }
// }