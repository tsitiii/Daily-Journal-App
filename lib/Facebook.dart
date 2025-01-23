import 'package:flutter/material.dart';

class FacebookHomePage extends StatefulWidget {
  @override
  _FacebookHomePageState createState() => _FacebookHomePageState();
}

class _FacebookHomePageState extends State<FacebookHomePage> {
  String name = "zion";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/facebook.png'), // Replace with your logo path
          onPressed: () {},
        ),
        title: const Text("Facebook"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                name = "I am zion😊😂😂😂"; // Update the name
              });
            },
          ),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),


      body: Column(
        children: [
          _buildPostInput(),
          Expanded(child: _buildPostList()),
        ],
      ),
    );
  }
  

  Widget _buildPostInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color.fromARGB(255, 231, 229, 229),
            child: Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2),
                foregroundColor: Colors.white // Facebook's primary color
                ),
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      itemCount: 5, // Number of sample posts
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                const Text("This is a sample post content."),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up),
                      label: const Text("Like"),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment),
                      label: const Text("Comment"),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
