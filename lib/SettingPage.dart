import 'package:demo_flutter/post.dart'; // Ensure this is the correct import for PostManager
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final Function(String, String, String) onPostCreated; // Updated callback to match three parameters

  const SettingPage({super.key, required this.onPostCreated}); // Make it required

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = _selectedTheme == 'Dark';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Select Theme",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedTheme,
              items: <String>['Light', 'Dark']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass the callback to PostManager
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostManager(
                      onPostCreated: widget.onPostCreated, // Pass the updated callback
                    ),
                  ),
                );
              },
              child: const Text(
                "Press Me",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home, color: Colors.purpleAccent),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings, color: Colors.blueGrey),
          ),
          BottomNavigationBarItem(
            label: 'Me',
            icon: Icon(Icons.favorite, color: Colors.pinkAccent),
          ),
        ],
      ),
      backgroundColor: isDarkTheme
          ? Colors.black
          : Colors.white,
    );
  }
}