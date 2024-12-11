import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDataFromApi();
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.194.236:5000/api/notifications'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _notifications = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showNotificationDetails(
      BuildContext context, String sender, String text, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message from $sender'),
          content: SingleChildScrollView(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9FB),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: const Color.fromARGB(255, 16, 16, 16),
            ))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final preview =
                    notification['text'].split(' ').take(5).join(' ') +
                        '...'; // Limit to a few words
                return Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  elevation: 1.0,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    leading:
                        Icon(Icons.notifications, color: Color(0xff111111)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['sender'],
                          style: TextStyle(
                              color: Color(0xff111111),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          notification['time'],
                          style: TextStyle(
                              color: Color(0xff777777),
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      preview,
                      style: TextStyle(color: Color(0xff111111)),
                    ),
                    onTap: () => _showNotificationDetails(
                      context,
                      notification['sender'],
                      notification['text'],
                      notification['time'],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
