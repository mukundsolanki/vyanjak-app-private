import 'package:flutter/material.dart';
import 'package:vtest/incoming_connect.dart';

class IncomingCallPage extends StatelessWidget {
  final String name;
  final String ipAddress;

  IncomingCallPage({required this.name, required this.ipAddress});

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
              'Incoming call from: $name',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'IP Address: $ipAddress',
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            IncomingConnect(ipAddress: ipAddress),
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
