import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    SymbolPage(), // This is your 'symbol_page.dart'
    Center(child: Text('Notifications Page')), // Placeholder for Notifications
    Center(child: Text('Call Page')), // Placeholder for Call
    Center(child: Text('Settings Page')), // Placeholder for Settings
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Clear user data (logout)
              userProvider.logout();

              // Clear login state from shared_preferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              // Navigate back to the login page
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display content based on current index
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        color: Colors.blue, // Background color of the navigation bar
        buttonBackgroundColor: Colors.blueGrey, // Background color of the middle button
        backgroundColor: Colors.transparent, // Background color of the entire bar
        animationCurve: Curves.easeInOut, // Animation curve for the transition
        animationDuration: Duration(milliseconds: 500), // Animation duration
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.call, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
