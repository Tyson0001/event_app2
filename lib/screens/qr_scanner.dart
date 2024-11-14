// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class QRScanner extends StatefulWidget {
//   const QRScanner({super.key});

//   @override
//   State<QRScanner> createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   bool isScanComplete = false;

//   void closeScreen() {
//     setState(() {
//       isScanComplete = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Scanner'),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             onDetect: (capture) {
//               if (!isScanComplete) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 if (barcodes.isNotEmpty) {
//                   final String? code = barcodes.first.rawValue;
//                   if (code != null) {
//                     setState(() {
//                       isScanComplete = true;
//                     });
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ResultScreen(
//                           code: code,
//                           onClose: closeScreen,
//                         ),
//                       ),
//                     );
//                   }
//                 }
//               }
//             },
//           ),
//           // Overlay for the QR code scan box
//           Center(
//             child: Container(
//               width: 250,
//               height: 250,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.green, width: 4),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ResultScreen extends StatelessWidget {
//   final String code;
//   final VoidCallback onClose;

//   const ResultScreen({super.key, required this.code, required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan Result'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             onClose();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Scanned Code: $code',
//             style: const TextStyle(fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }





































// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class QRScanner extends StatefulWidget {
//   const QRScanner({super.key});

//   @override
//   State<QRScanner> createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   bool isScanComplete = false; // to prevent multiple scans
//   Rect? barcodeRect; // to draw the rectangle around the barcode

//   void closeScreen() {
//     setState(() { // Always use setState to update the UI
//       isScanComplete = false;
//       barcodeRect = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Scanner'),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             onDetect: (capture) {
//               if (!isScanComplete) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 if (barcodes.isNotEmpty) { // If barcode is detected
//                   final String? code = barcodes.first.rawValue; // Get the barcode value
//                   final List<Offset>? corners = barcodes.first.corners; // Get the corners of the barcode

//                   if (corners != null && corners.length == 4) { // If corners are detected
//                     final double left = corners.map((e) => e.dx).reduce((a, b) => a < b ? a : b); // Get the leftmost corner
//                     final double top = corners.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
//                     final double right = corners.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
//                     final double bottom = corners.map((e) => e.dy).reduce((a, b) => a > b ? a : b);

//                     setState(() { // Update the UI
//                       barcodeRect = Rect.fromLTRB(left, top, right, bottom);
//                     });
//                   }

//                   if (code != null) { // If code is not null
//                     setState(() {
//                       isScanComplete = true;
//                     });
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ResultScreen(
//                           code: code,
//                           onClose: closeScreen,
//                         ),
//                       ),
//                     );
//                   }
//                 }
//               }
//             },
//           ),

//           if (barcodeRect != null)
//             Positioned(
//               left: barcodeRect!.left,
//               top: barcodeRect!.top,
//               width: barcodeRect!.width,
//               height: barcodeRect!.height,
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.red, width: 3),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class ResultScreen extends StatelessWidget {
//   final String code;
//   final VoidCallback onClose;

//   const ResultScreen({super.key, required this.code, required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan Result'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             onClose();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Scanned Code: $code',
//             style: const TextStyle(fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }










































import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'first_page.dart';  // Import the FirstPage

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final MobileScannerController _controller = MobileScannerController(); // Controller for pausing/resuming
  bool _isFlashOn = false; // Flag to track flashlight state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        centerTitle: true,
        actions: [
          // Flashlight toggle button
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
              _controller.toggleTorch(); // Toggle flashlight
            },
          ),
          // Icon to navigate back to FirstPage
          IconButton(
            icon: const Icon(Icons.home), // You can use any icon you'd like
            onPressed: () {
              // Navigate back to FirstPage
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

                if (code != null) {
                  _controller.stop(); // Pause scanning
                  _showResult(context, code);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showResult(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Result'),
        content: Text('Scanned Code: $code'),
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
























// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'dart:async';

// class QRScanner extends StatefulWidget {
//   const QRScanner({super.key});

//   @override
//   State<QRScanner> createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   final MobileScannerController _controller = MobileScannerController();
//   String? _lastDetectedCode;
//   Timer? _detectionTimer;
//   bool _isScanningPaused = false; // To pause and resume scanning.

//   void _startTimer(String code) {
//     _detectionTimer?.cancel(); // Cancel any existing timer.
//     _detectionTimer = Timer(const Duration(seconds: 2), () {
//       if (_lastDetectedCode == code && !_isScanningPaused) {
//         _isScanningPaused = true; // Pause further detection.
//         _controller.stop(); // Pause camera scanning.
//         _showResult(context, code); // Show result after validation.
//       }
//     });
//   }

//   void _resetTimer() {
//     _detectionTimer?.cancel();
//     _lastDetectedCode = null;
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
//               _resetTimer();
//               setState(() {
//                 _isScanningPaused = false;
//               });
//               _controller.start(); // Resume scanning after the user presses OK.
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
//       appBar: AppBar(
//         title: const Text('QR Scanner'),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: _controller,
//             onDetect: (capture) {
//               if (!_isScanningPaused) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 if (barcodes.isNotEmpty) {
//                   final String? code = barcodes.first.rawValue;
//                   if (code != null) {
//                     if (_lastDetectedCode == code) {
//                       _startTimer(code); // Start/Restart the timer if code matches.
//                     } else {
//                       _resetTimer(); // Reset if a new code is detected.
//                       _lastDetectedCode = code;
//                       _startTimer(code);
//                     }
//                   }
//                 }
//               }
//             },
//           ),
//           Center(
//             child: Container(
//               width: 250,
//               height: 250,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.green, width: 4),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _detectionTimer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
// }
