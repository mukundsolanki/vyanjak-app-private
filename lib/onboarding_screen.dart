import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 175, 201, 236), // Light blue background color
          ),
          _buildBackgroundCircles(), // Adding dark background circles
          IntroductionScreen(
            globalBackgroundColor: Colors.transparent, // Make background transparent to show circles
            pages: [
              _buildPageViewModel(
                imagePath: 'assets/intro/welcome.png',
                title: "Welcome to Vyanjak",
                description: "An app designed to help deaf individuals communicate effectively",
                bulletPoints: "• Easy to use\n• Accessible\n• Reliable",
              ),
              _buildPageViewModel(
                imagePath: 'assets/intro/device.png',
                title: "Scan the QR Code",
                description: "Start by scanning the QR code on the intercom device",
                bulletPoints: "• Quick setup\n• Secure access\n• User-friendly",
              ),
              _buildPageViewModel(
                imagePath: 'assets/intro/notif.png',
                title: "Receive Notifications",
                description: "Get notified when someone wants to communicate",
                bulletPoints: "• Instant alerts\n• Stay connected\n• Never miss a message",
              ),
              _buildPageViewModel(
                imagePath: 'assets/intro/videocall.png',
                title: "Make Video Calls",
                description: "Easily make video calls to communicate",
                bulletPoints: "• High-quality video\n• Real-time communication\n• Easy to use",
              ),
              _buildPageViewModel(
                imagePath: 'assets/intro/videomail.png',
                title: "Leave Video Messages",
                description: "If you're busy, a video message will be left for you to view later",
                bulletPoints: "• Convenient\n• Accessible anytime\n• Easy playback",
              ),
              _buildPageViewModelWithButton(
                imagePath: 'assets/intro/scan.png',
                title: "Login with QR Code",
                description: "Scan and proceed.",
              ),
            ],
            onDone: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => QRScannerPage()),
              );
            },
            onSkip: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => QRScannerPage()),
              );
            },
            showSkipButton: true,
            skip: const Text('Skip',
                style: TextStyle(color: Colors.white, fontSize: 16.0)), // Changed to deep navy
            next: const Icon(Icons.arrow_forward, color: Colors.white), // Changed to deep navy
            done: const Text('Done',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0)),
            dotsDecorator: DotsDecorator(
              size: const Size(10.0, 10.0),
              activeSize: const Size(22.0, 10.0),
              activeColor: Colors.white, 
              color: Colors.white38,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to create background circles
  Widget _buildBackgroundCircles() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 30,
            child: _buildCircle(120, const Color(0xFF8AAAE5).withOpacity(0.7)), 
          ),
          Positioned(
            bottom: 150,
            right: 40,
            child: _buildCircle(150,  const Color(0xFF8AAAE5).withOpacity(0.4)),
          ),
          Positioned(
            top: 180,
            right: -40,
            child: _buildCircle(200,  const Color(0xFF8AAAE5).withOpacity(0.4)),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: _buildCircle(200,  const Color(0xFF8AAAE5).withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  // Helper method to create a circle
  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  PageViewModel _buildPageViewModel({
    required String imagePath,
    required String title,
    required String description,
    required String bulletPoints,
  }) {
    return PageViewModel(
      title: "",
      bodyWidget: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Rounded image corners
              child: Image.asset(
                imagePath,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Changed to dark blue
                
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white, 
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              bulletPoints,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white, 
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      decoration: getPageDecoration(),
    );
  }

  PageViewModel _buildPageViewModelWithButton({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return PageViewModel(
      title: "",
      bodyWidget: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Rounded image corners
              child: Image.asset(
                imagePath,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Changed to dark blue
               
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white, // Changed to deep navy
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white60, // Changed to dark blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Scan QR Code',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => QRScannerPage()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      decoration: getPageDecoration().copyWith(
        contentMargin: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16.0),
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: const TextStyle(fontSize: 16.0, color: Colors.white), 
      imagePadding: const EdgeInsets.all(24.0),
      contentMargin: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 0),
      pageColor: Colors.transparent, 
    );
  }
}
