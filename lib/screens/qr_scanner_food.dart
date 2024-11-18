import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

import 'first_page.dart';

class QrScannerFood extends StatefulWidget {
  const QrScannerFood({super.key});

  @override
  State<QrScannerFood> createState() => _QrScannerFoodState();
}

class _QrScannerFoodState extends State<QrScannerFood> {
  MobileScannerController? _controller;
  final TextEditingController _eventCodeController = TextEditingController();
  bool _isFlashOn = false;
  String? secondUsername;
  bool _hasPermission = false;
  String _errorMessage = '';


  @override
  void initState() {
    super.initState();
    _initializeScanner();
    _loadUsernameFromToken();
  }

  Future<void> _initializeScanner() async {
    // Request camera permission
    final status = await Permission.camera.request();
    
    setState(() {
      _hasPermission = status.isGranted;
      if (_hasPermission) {
        _controller = MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: _isFlashOn,
        );
        _errorMessage = '';
      } else {
        _errorMessage = 'Camera permission is required to use the scanner';
      }
    });
  }

  Future<void> _loadUsernameFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token != null && !JwtDecoder.isExpired(token)) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        setState(() {
          secondUsername = decodedToken['username'];
        });
      } else {
        _showResult(context, 'Invalid or expired token. Please log in again.');
      }
    } catch (e) {
      _showResult(context, 'Error loading user data: $e');
    }
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
      body: Stack(
        children: [
          if (_hasPermission && _controller != null)
            MobileScanner(
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

                  if (code != null && secondUsername != null && _eventCodeController.text.isNotEmpty) {
                    _controller?.stop();
                    _fetchFromServer(code, secondUsername!, _eventCodeController.text);
                  } else if (_eventCodeController.text.isEmpty) {
                    _showResult(context, 'Please enter an event code.');
                  }
                }
              },
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
                    onPressed: _initializeScanner,
                    child: const Text('Request Camera Permission'),
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                TextField(
                  controller: _eventCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Event Code',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Refresh to retain event code
                  },
                  child: const Text('Set Event Code'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchFromServer(String code, String secondUsername, String eventCode) async {
    final url = Uri.parse('https://gatherhub-r7yr.onrender.com/user/conference/$eventCode/move-attendee');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': code,
        }),
      );

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
              _controller?.start(); // Resume scanning
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _eventCodeController.dispose();
    super.dispose();
  }
}