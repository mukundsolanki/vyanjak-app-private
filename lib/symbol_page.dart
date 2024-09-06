import 'package:flutter/material.dart';

class SymbolPage extends StatefulWidget {
  const SymbolPage({super.key});

  @override
  State<SymbolPage> createState() => _SymbolPageState();
}

class _SymbolPageState extends State<SymbolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(12.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0), 
              child: Text(
                'Choose whom to call:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0, 
                  mainAxisSpacing: 10.0, 
                ),
                itemCount: 14, 
                itemBuilder: (context, index) {
                  return _buildGridItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
  
    final List<Map<String, dynamic>> items = [
      {'image': 'assets/medicine.png', 'size': 70.0}, 
      {'image': 'assets/bus.png', 'size': 70.0}, 
      {'image': 'assets/guard.png', 'size': 80.0}, 
      {'image': 'assets/teacher.png', 'size': 85.0}, 
      {'image': 'assets/peon.png', 'size': 80.0},
      {'image': 'assets/food.png', 'size': 60.0}, 
      {'image': 'assets/dean.png', 'size': 70.0}, 
      {'image': 'assets/policeman.png', 'size': 70.0}, 
      {'image': 'assets/one.png', 'size': 40.0}, 
      {'image': 'assets/two.png', 'size': 40.0}, 
      {'image': 'assets/three.png', 'size': 40.0}, 
      {'image': 'assets/four.png', 'size': 40.0},
      {'image': 'assets/meeting.png', 'size': 70.0}, 
      {'image': 'assets/add-user.png', 'size': 50.0}, 
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 6.0,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          
        },
        splashColor: Colors.deepPurple.withAlpha(30),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Center(
            child: Image.asset(
              items[index]['image'],
              height: items[index]['size'], 
            ),
          ),
        ),
      ),
    );
  }
}