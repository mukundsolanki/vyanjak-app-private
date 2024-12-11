import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer
import 'package:vibration/vibration.dart'; // Import for vibration
import 'package:vtest/incoming_connect.dart';

class IncomingCallPage extends StatefulWidget {
  final String name;
  final String ipAddress;

  IncomingCallPage({required this.name, required this.ipAddress});

  @override
  _IncomingCallPageState createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    _startVibration();
  }

  @override
  void dispose() {
    _vibrationTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startVibration() {
    // Check if vibration is supported and then start the vibration loop
    Vibration.hasVibrator().then((bool? hasVibrator) {
      if (hasVibrator ?? false) {
        _vibrationTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
          Vibration.vibrate();
        });
      }
    });
  }

  void _stopVibration() {
    // Cancel the vibration timer
    _vibrationTimer?.cancel();
    Vibration.cancel(); // Stop any ongoing vibration
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incoming Call'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incoming call from: ${widget.name}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'IP Address: ${widget.ipAddress}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    _stopVibration(); // Stop vibration when the call is rejected
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Reject',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    _stopVibration(); // Stop vibration when the call is accepted
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            IncomingConnect(ipAddress: widget.ipAddress),
                      ),
                    );
                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
