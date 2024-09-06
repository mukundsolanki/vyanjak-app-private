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
          // Gradient background color
          Container(
            color:Color(0xFFB0C4DE),
 
),
          // Positioned AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150, // Height for the AppBar
              decoration: BoxDecoration(
                color: Color(0xFF8AAAE5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0), // Padding for content inside AppBar
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[ Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Vyanjak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                      userProvider.logout();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0), 
                  Text(
                    _pageTitles[_currentIndex] ?? '',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ]
              )
              
            ),
          ),
          // Body content
          Positioned(
            top: 120, // Position the body content below the AppBar
            left: 16,
            right: 16,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
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
        height: 60, // Height for bottom navigation bar
        child: CurvedNavigationBar(
          index: _currentIndex,
          height: 60,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          color: Color(0xFF8AAAE5),
          buttonBackgroundColor: Color(0xFF8AAAE5),
          backgroundColor: Colors.transparent,
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
