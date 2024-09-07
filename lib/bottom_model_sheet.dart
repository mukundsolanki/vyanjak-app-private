import 'package:flutter/material.dart';

class AddPeopleBottomSheet extends StatefulWidget {
  final Function(String, String) onAdd;

  AddPeopleBottomSheet({required this.onAdd});

  @override
  _AddPeopleBottomSheetState createState() => _AddPeopleBottomSheetState();
}

class _AddPeopleBottomSheetState extends State<AddPeopleBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add People',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF227C9D), // Darker blue for text
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Color(0xFF227C9D)), // Darker blue for icon
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter name',
                labelStyle: TextStyle(color: Color(0xFF227C9D)), // Darker blue for label
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8AAAE5)), // Light blue for focused border
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              style: TextStyle(fontSize: 16.0, color: Color(0xFF227C9D)), // Darker blue for text
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: 'Enter IP Address',
                      labelStyle: TextStyle(color: Color(0xFF227C9D)), // Darker blue for label
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8AAAE5)), // Light blue for focused border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF227C9D)), // Darker blue for text
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final ip = _ipController.text.trim();
                    if (name.isNotEmpty && ip.isNotEmpty) {
                      widget.onAdd(name, ip);
                      _nameController.clear();
                      _ipController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove default padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // Add elevation for shadow
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                     color: Color(0xFF8AAAE5),
                      borderRadius: BorderRadius.circular(8.0),
                      
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}