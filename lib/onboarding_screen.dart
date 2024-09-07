import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login_page.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Color(0xFF8AAAE5),
      pages: [
        PageViewModel(
          title: "Welcome to Vyanjak",
          body: "An app designed to help deaf individuals communicate effectively",
          image: Center(
            child: Image.asset(
              'assets/intro/welcome.png',
              width: 150,
              height: 150,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Scan the QR Code",
          body: "Start by scanning the QR code on the intercom device",
          image: Center(
            child: Image.asset(
              'assets/intro/device.png',
              width: 150,
              height: 150,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Receive Notifications",
          body: "Get notified when someone wants to communicate",
          image: Center(
            child: Image.asset(
              'assets/intro/notif.png',
              width: 150,
              height: 150,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Make Video Calls",
          body: "Easily make video calls to communicate ",
          image: Center(
            child: Image.asset(
              'assets/intro/videocall.png',
              width: 150,
              height: 150,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Leave Video Messages",
          body: "If you're busy, video message will be left for you to view later",
          image: Center(
            child: Image.asset(
              'assets/intro/videomail.png',
              width: 150,
              height: 150,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Login with QR Code",
          body: "Scan the QR code to proceed.",
          image: Center(
            child: Image.asset(
              'assets/intro/scan.png',
              width: 120,
              height: 150,
            ),
          ),
          footer: Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Scan QR Code',
                  style: TextStyle(color: Colors.blue, fontSize: 15.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => QRScannerPage()),
                  );
                },
              ),
            ),
          ),
          decoration: getPageDecoration().copyWith(
            contentMargin: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16.0),
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
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
          style: TextStyle(color: Colors.white, fontSize: 16.0)),
      next: const Icon(Icons.arrow_forward, color: Colors.white),
      done: const Text('Done',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.0)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.white,
        color: Colors.black26,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.white), // White for title
      bodyTextStyle:
          TextStyle(fontSize: 18.0, color: Colors.white), // White for body
      imagePadding: EdgeInsets.all(24.0),
      contentMargin: EdgeInsets.symmetric(horizontal: 16.0)
          .copyWith(bottom: 0), // Center content
      pageColor: Color(0xFF8AAAE5),
    );
  }
}