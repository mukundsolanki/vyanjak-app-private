import 'package:flutter/material.dart';
import 'dart:convert'; // To decode JSON
import 'package:http/http.dart' as http;
import 'video_player_page.dart';  // Import the new file

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  late Map<String, dynamic> _lastDeletedNotification;
  late int _lastDeletedIndex;

  @override
  void initState() {
    super.initState();
    _fetchDataFromApi();
  }

  Future<void> _fetchDataFromApi() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.29.192:5000/api/notifications'));
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playVideo(String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
      ),
    );
  }

  void _deleteNotification(int index) {
    setState(() {
      _lastDeletedNotification = _notifications[index];
      _lastDeletedIndex = index;
      _notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: Text('Notification deleted')),
              SizedBox(width: 8),
              TextButton(
                child: Text('Undo'),
                onPressed: () {
                  _restoreNotification();
                },
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _restoreNotification() {
    setState(() {
      _notifications.insert(_lastDeletedIndex, _lastDeletedNotification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification['name']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteNotification(index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(Icons.notifications, color: Colors.blue),
                      title: Text(notification['name']),
                      subtitle: Text('Tap to play video'),
                      trailing: Icon(Icons.play_circle_filled),
                      onTap: () => _playVideo(notification['video']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
