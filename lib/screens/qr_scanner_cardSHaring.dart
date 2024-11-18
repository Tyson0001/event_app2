
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'first_page.dart';  // Import the FirstPage

// class QRScanner extends StatefulWidget {
//   const QRScanner({super.key});

//   @override
//   State<QRScanner> createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   final MobileScannerController _controller = MobileScannerController(); // Controller for pausing/resuming
//   bool _isFlashOn = false; // Flag to track flashlight state

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Scanner'),
//         centerTitle: true,
//         actions: [
//           // Flashlight toggle button
//           IconButton(
//             icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
//             onPressed: () {
//               setState(() {
//                 _isFlashOn = !_isFlashOn;
//               });
//               _controller.toggleTorch(); // Toggle flashlight
//             },
//           ),
//           // Icon to navigate back to FirstPage
//           IconButton(
//             icon: const Icon(Icons.home), // You can use any icon you'd like
//             onPressed: () {
//               // Navigate back to FirstPage
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const FirstPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: _controller,
//             onDetect: (capture) {
//               final List<Barcode> barcodes = capture.barcodes;
//               if (barcodes.isNotEmpty) {
//                 final String? code = barcodes.first.rawValue;

//                 if (code != null) {
//                   _controller.stop(); // Pause scanning
//                   _showResult(context, code);
//                 }
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _showResult(BuildContext context, String code) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Scan Result'),
//         content: Text('Scanned Code: $code'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _controller.start(); // Resume scanning
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }












import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'first_page.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isFlashOn = false;
  String? secondUsername;

  @override
  void initState() {
    super.initState();
    _loadUsernameFromToken();
  }

  Future<void> _loadUsernameFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null && JwtDecoder.isExpired(token) == false) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        secondUsername = decodedToken['username']; // Adjust based on your token structure
      });
    } else {
      _showResult(context, 'Invalid or expired token. Please log in again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'), 
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
              _controller.toggleTorch();
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
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;

                if (code != null && secondUsername != null) {
                  _controller.stop();
                  _fetchFromServer(code, secondUsername!);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _fetchFromServer(String code, String secondUsername) async {
    final url = Uri.parse('https://gatherhub-r7yr.onrender.com/user/shareCard/$code/$secondUsername');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _showResult(context, 'Success: ${result['message']}');
      } else {
        _showResult(context, 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showResult(context, 'Error: $e');
    }
  }

  void _showResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Server Response'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _controller.start(); // Resume scanning
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
