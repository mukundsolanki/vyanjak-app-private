import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vtest/onboarding_screen.dart';
import 'user_provider.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: OnboardingScreen(),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code",style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF8AAAE5), // Enhanced color
        actions: [
          IconButton(
            icon: Icon(
              cameraController.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: Icon(
              cameraController.cameraFacing == CameraFacing.front
                  ? Icons.camera_front
                  : Icons.camera_rear,
              color: Colors.white,
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue == null) {
              return;
            }

            final String qrData = barcode.rawValue!;
            try {
              // Parse the JSON data from the QR code
              final Map<String, dynamic> jsonData = jsonDecode(qrData);
              final name = jsonData['name'];
              final role = jsonData['role'];

              // Save the login state to shared_preferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('name', name);
              await prefs.setString('role', role);

              // Update the UserProvider state
              context.read<UserProvider>().login(name, role);

              // Navigate to the home page
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } catch (e) {
              // Show error message if QR code is not valid JSON
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Invalid QR code")),
              );
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

extension on MobileScannerController {
  get cameraFacing => null;
}