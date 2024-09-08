import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:vtest/call_page.dart';
import 'package:vtest/notification_page.dart';
import 'package:vtest/settings.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'symbol_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SymbolPage(),
    NotificationPage(),
    CallPage(),
    SettingsPage(),
  ];
  final Map<int, String> _pageTitles = {
    0: 'Select a Symbol to Connect',
    1: 'Notifications',
    2: 'Calls',
    3: 'Settings',
  };

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Color(0xffBFFF6D),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                    20, 42, 16, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vyanjak',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () async {
                              userProvider.logout();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        _pageTitles[_currentIndex] ?? '',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 19,
                        ),
                      ),
                    ])),
          ),
          // Body content
          Positioned(
            top: 140,
            left: 15,
            right: 15,
            bottom: 13,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Container(
                color: Colors.white,
                child: _pages[_currentIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: CurvedNavigationBar(
          index: _currentIndex,
          height: 60,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          color: Color(0xff111111),
          buttonBackgroundColor: Color(0xffBFFF6D),
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          items: const <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.notifications, size: 30, color: Colors.white),
            Icon(Icons.call, size: 30, color: Colors.white),
            Icon(Icons.settings, size: 30, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
