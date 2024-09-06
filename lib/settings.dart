import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Hardcoded battery and connectivity status
  final String batteryStatus = "80%";
  final String connectivityStatus = "WiFi";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      // Gradient background
      body: Container(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    const SizedBox(height: 16),
              Column(
                children:[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      _buildSquareCard(
                        icon: Icons.person,
                        title: 'User',
                        subtitle: userProvider.name,
                      ),
                      _buildSquareCard(
                        icon: Icons.person,
                        title: 'Role',
                        subtitle: userProvider.role,
                      ),
                    ]
                  ),
                   Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSquareCard(
                    icon: Icons.battery_full,
                    title: 'Battery',
                    subtitle: batteryStatus,
                  ),
                  _buildSquareCard(
                    icon: Icons.wifi,
                    title: 'Connectivity',
                    subtitle: connectivityStatus,
                  ),
                ],
              ),
                ]
              )
             
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF8AAAE5), // Light blue background
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF227C9D), // Darker blue for text
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Color(0xFF227C9D), // Darker blue for subtitle
              ),
            ),
          ],
        ),
      ),
    );
  }
}