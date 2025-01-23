import 'dart:io'; // Import dart:io for File

import 'package:flutter/material.dart';

import 'post.dart'; // Import PostManager

class PostPage extends StatefulWidget {
  PostPage({super.key});

  @override
  State<PostPage> createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  List<Map<String, String>> _posts = []; // List to store posts

  void _addPost(String imagePath, String title, String caption) {
    setState(() {
      _posts.add({
        'image': imagePath,
        'title': title,
        'caption': caption,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Page'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: _posts.isEmpty
          ? Center(child: Text('No posts available.'))
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (post['image'] != null)
                        Image.file(File(post['image']!), fit: BoxFit.cover),
                      ListTile(
                        title: Text(post['title']!),
                        subtitle: Text(post['caption']!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostManager(onPostCreated: _addPost)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
