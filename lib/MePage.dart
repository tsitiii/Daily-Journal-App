import 'package:flutter/material.dart';

import 'auth/LoginPage.dart';
import 'auth/auth_service.dart';
import 'notification.dart';
import 'postpage.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final _auth = AuthService();
  String _firstName = '';
  String _lastName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = await _auth.getCurrentUser();
    if (user != null) {
      // Fetch user data from Firestore
      // DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        // _firstName = userData['firstName'] ?? 'No First Name';
        // _lastName = userData['lastName'] ?? 'No Last Name';
        _email = user.email ?? 'No Email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Search icon
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.purple,
                child: Icon(
                  Icons.person_4_outlined,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "$_firstName $_lastName",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _email,
                style: TextStyle(
                  fontSize: 16,
                  // color: Colors.purpleAccent,
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.purpleAccent),
                title: Text("See Your posts"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Change Password"),
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Notifications"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.redAccent),
                title: Text("Logout"),
                onTap: () async {
                  await _auth.signOut();
                  goToLogin(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );

  Future<void> _showChangePasswordDialog() async {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Change'),
              onPressed: () async {
                String currentPassword = _currentPasswordController.text;
                String newPassword = _newPasswordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (newPassword == confirmPassword) {
                  // Call your password change function here
                  await _changePassword(currentPassword, newPassword);
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    try {
      // Assuming you have a method in AuthService to change the password
      await _auth.changePassword(currentPassword, newPassword);
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );
    } catch (e) {
      // Handle errors, such as incorrect current password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
