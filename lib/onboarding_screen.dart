import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login_page.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "This is the introduction to our app.",
          image: Center(
            child: Image.asset(
              'assets/intro/welcome.png',
              width: 100,
              height: 100,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Open Intercom",
          body: "Open the intercom and scan the QR code.",
          image: Center(
            child: Image.asset(
              'assets/intro/device.png',
              width: 100,
              height: 100,
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: "Scan QR Code",
          body: "Scan the QR code to proceed.",
          image: Center(
            child: Image.asset(
              'assets/intro/scan.png',
              width: 100,
              height: 100,
            ),
          ),
          footer: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8AAAE5),
            ),
            child: Text('Scan QR Code', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => QRScannerPage()),
              );
            },
          ),
          decoration: getPageDecoration(),
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
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Color(0xFF8AAAE5),
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
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 18.0),
      imagePadding: EdgeInsets.all(24.0),
      pageColor: Colors.white,
    );
  }
}
