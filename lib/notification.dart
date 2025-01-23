import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat"),
        ),
        backgroundColor: Colors.purple,
      ),

      body: Center(
        child: Text("Nothing in here",
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20,
          fontWeight:FontWeight.w400,
        ),),
      
      ),
    );
  }
}