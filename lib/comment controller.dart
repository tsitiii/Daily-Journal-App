import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your DatabaseHelper

// User model to represent the logged-in user
class User {
  final String username;

  User(this.username);
}

// Comment model to represent a comment with username and text
class Comment {
  final String username;
  final String text;

  Comment(this.username, this.text);
}

class CommentPage extends StatefulWidget {
  final User user; // Add a user parameter

  const CommentPage({super.key, required this.user}); // Require the user

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> comments = []; // List of Comment objects
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Instantiate DatabaseHelper

  void _showCommentDialog() {
    final TextEditingController commentController = TextEditingController();

    // Check if the user is logged in
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // User is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to add a comment.')),
      );
      return; // Exit the function
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final commentText = commentController.text;
                if (commentText.isNotEmpty) {
                  // Create a Comment object
                  final newComment = Comment(widget.user.username, commentText);

                  // Add comment to the list and close the dialog
                  setState(() {
                    comments.add(newComment);
                  });

                  // Save the comment to the database
                  await _saveCommentToDatabase(newComment);

                  Navigator.of(context).pop();
                } else {
                  // Handle empty comment case
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Comment cannot be empty.')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCommentToDatabase(Comment comment) async {
    final post = {
      'username': comment.username,
      'text': comment.text,
    };
    await _databaseHelper.insertPost(post); // Save to database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${comments[index].username}: ${comments[index].text}'),
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: _showCommentDialog, // Show comment dialog on press
            icon: const Icon(Icons.comment),
            label: const Text('Add Comment'),
          ),
        ],
      ),
    );
  }
}