import 'dart:convert'; // For Base64 encoding
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'database_helper.dart'; // Ensure this import is correct

class PostManager extends StatefulWidget {
  final Function(String, String, String) onPostCreated;

  const PostManager({super.key, required this.onPostCreated});

  @override
  State<PostManager> createState() => _PostManagerState();
}

class _PostManagerState extends State<PostManager> {
  File? selectedImage; // For mobile
  String? selectedImageUrl; // For web
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Manager'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tap to Select Image',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              selectedImage != null || selectedImageUrl != null
                  ? Container(
                      width: 350,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(
                                selectedImageUrl!,
                                fit: BoxFit.contain,
                              )
                            : Image.file(
                                selectedImage!,
                                fit: BoxFit.contain,
                              ),
                      ),
                    )
                  : Text("Please select an image"),
              SizedBox(height: 20),
              _buildTextField(titleController, 'Enter Title', maxLength: 100),
              SizedBox(height: 20),
              _buildTextField(captionController, 'Enter Caption'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePost,
                child: Text('Post'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,{int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        maxLength: maxLength,
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            selectedImageUrl = pickedFile.path; 
          } else {
            selectedImage = File(pickedFile.path);
            selectedImageUrl =
                pickedFile.path; 
          }
        });
        print('Image path: ${pickedFile.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _savePost() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to create a post.')),
        );
        return;
      }

      String title = titleController.text.trim();
      String caption = captionController.text.trim();
      String userId = user.uid;

      if (title.isEmpty ||
          caption.isEmpty ||
          (selectedImage == null && selectedImageUrl == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Title, caption, or image cannot be empty.')),
        );
        return;
      }

      await DatabaseHelper().insertPost({
        'title': title,
        'caption': caption,
        'image': selectedImage, // Save the Base64 string
        'userId': userId,
      });

      print('Post saved locally');
      widget.onPostCreated(
          selectedImage != null ? selectedImage!.path : selectedImageUrl!,
          title,
          caption);
      titleController.clear();
      captionController.clear();
      setState(() {
        selectedImage = null;
        selectedImageUrl = null;
      });
    } catch (e) {
      print('Error saving post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving post: $e')),
      );
    }
  }
}
