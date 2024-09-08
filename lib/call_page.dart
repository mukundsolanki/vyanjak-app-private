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
      isScrollControlled: true,
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
      backgroundColor: Color(0xffF9F9FB),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: people.isEmpty
            ? Center(
                child: Text(
                  'No one to call',
                  style: TextStyle(
                    color: Color.fromARGB(255, 10, 10, 10),
                    fontSize: 18,
                  ),
                ),
              )
            : ListView(
                children: people
                    .map((person) =>
                        _buildCallCard(person['name']!, person['ip']!))
                    .toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPeopleBottomSheet,
        backgroundColor: Color.fromARGB(255, 1, 1, 1),
        child: Icon(Icons.add, color: Color(0xffBFFF6D)),
      ),
    );
  }

  Widget _buildCallCard(String name, String ip) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.0,
              backgroundColor: Color.fromARGB(255, 9, 9, 9),
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: TextStyle(color: Color(0xffBFFF6D), fontSize: 25.0),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 10, 10, 10),
                        ),
                      ),
                      SizedBox(height: 4.0),
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
                      SizedBox(height: 4.0),
                      Text(
                        'IP: $ip',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.call,
                        color: Color.fromARGB(255, 8, 8, 8), size: 30.0),
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
