import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vtest/bottom_model_sheet.dart';
import 'package:vtest/video_call_page.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  List<Map<String, String>> people = [];

  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  Future<void> _loadPeople() async {
    final prefs = await SharedPreferences.getInstance();
    final peopleList = prefs.getStringList('people') ?? [];
    setState(() {
      people = peopleList.map((person) {
        final parts = person.split('|');
        return {'name': parts[0], 'ip': parts[1]};
      }).toList();
    });
  }

  Future<void> _savePeople() async {
    final prefs = await SharedPreferences.getInstance();
    final peopleList =
        people.map((person) => '${person['name']}|${person['ip']}').toList();
    prefs.setStringList('people', peopleList);
  }

  void _showAddPeopleBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddPeopleBottomSheet(
          onAdd: (name, ip) {
            setState(() {
              people.add({'name': name, 'ip': ip});
              _savePeople();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Page'),
      ),
      body: people.isEmpty
          ? Center(
              child: Text('No one to call'),
            )
          : ListView(
              children: people
                  .map((person) =>
                      _buildCallCard(person['name']!, person['ip']!))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPeopleBottomSheet,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCallCard(String name, String ip) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor:
                  Colors.blueGrey,
              child: Text(
                name.isNotEmpty
                    ? name[0]
                    : '?',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 12.0),
                          SizedBox(width: 4.0),
                          Text(
                            'Online',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'IP: $ip',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.call, color: Colors.blue, size: 30.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoCallPage(ipAddress: ip),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
