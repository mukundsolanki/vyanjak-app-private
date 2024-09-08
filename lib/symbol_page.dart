import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SymbolPage extends StatefulWidget {
  const SymbolPage({super.key});

  @override
  State<SymbolPage> createState() => _SymbolPageState();
}

class _SymbolPageState extends State<SymbolPage> {
  final List<Map<String, dynamic>> items = [
    {'image': 'assets/symbols/medicine.png', 'size': 70.0},
    {'image': 'assets/symbols/bus.png', 'size': 60.0},
    {'image': 'assets/symbols/guard.png', 'size': 80.0},
    {'image': 'assets/symbols/teacher.png', 'size': 85.0},
    {'image': 'assets/symbols/peon.png', 'size': 80.0},
    {'image': 'assets/symbols/food.png', 'size': 60.0},
    {'image': 'assets/symbols/dean.png', 'size': 60.0},
    {'image': 'assets/symbols/policeman.png', 'size': 60.0},
    {'image': 'assets/symbols/one.png', 'size': 40.0},
    {'image': 'assets/symbols/two.png', 'size': 40.0},
    {'image': 'assets/symbols/three.png', 'size': 40.0},
    {'image': 'assets/symbols/four.png', 'size': 40.0},
    {'image': 'assets/symbols/meeting.png', 'size': 70.0},
    {'image': 'assets/symbols/add-user.png', 'size': 30.0},
  ];

  final List<Map<String, dynamic>> userItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9FB),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: items.length + userItems.length,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return _buildGridItem(index, items);
                  } else {
                    return _buildGridItem(index - items.length, userItems);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index, List<Map<String, dynamic>> itemList) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 0.0,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          if (itemList == items && index == items.length - 1) {
            await _addUser();
          }
        },
        splashColor: const Color.fromARGB(255, 255, 255, 255).withAlpha(30),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: itemList == items
                ? Image.asset(
                    itemList[index]['image'],
                    height: itemList[index]['size'],
                  )
                : CircleAvatar(
                    backgroundImage: FileImage(File(itemList[index]['image'])),
                    radius: itemList[index]['size'] / 2,
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _addUser() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final nameController = TextEditingController();
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Name'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    userItems.add({
                      'image': pickedFile.path,
                      'size': 70.0,
                      'name': nameController.text,
                    });
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }
  }
}
