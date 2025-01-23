import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart'; // Change this based on your platform support
import 'package:sembast_web/sembast_web.dart'; // For web support

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  late DatabaseFactory databaseFactory;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (kIsWeb) {
      databaseFactory = databaseFactoryWeb;
    } else {
      // Initialize for other platforms (e.g., desktop, mobile)
      // databaseFactory = databaseFactoryMemory; // Adjust based on your requirement
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbName = 'posts.db';
    final database = await databaseFactory.openDatabase(dbName);
    final postsStore = intMapStoreFactory.store('posts');
    final likesStore = intMapStoreFactory.store('likes');
    if (await postsStore.record(0).get(database) == null) {
      print("No posts in the database");
    }

    return database; 
  }

  Future<void> insertPost(Map<String, dynamic> post) async {
    try {
      final db = await database;
      final store = intMapStoreFactory.store('posts');

      await store.add(db, post);
      print("Inserting post: $post");
    } catch (e) {
      print("Error inserting post: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    try {
      final db = await database;
      final store = intMapStoreFactory.store('posts');
      final records = await store.find(db);
      print("Records fetched: $records"); // Debug print
      return records.map((record) => record.value).toList();
    } catch (e) {
      print("Error fetching posts: $e");
      return []; // Return an empty list on error
    }
  }

  Future<Map<String, dynamic>?> getPostById(int id) async {
    try {
      final db = await database;
      final store = intMapStoreFactory.store('posts');

      final record = await store.record(id).get(db);
      return record; // This returns the value associated with the record
    } catch (e) {
      print("Error fetching post by ID: $e");
      return null; // Return null on error
    }
  }

  // Likes related methods
  Future<void> insertLike(int postId, String userId) async {
    try {
      final db = await database;
      final store = intMapStoreFactory.store('likes');
      final like = {
        'postId': postId,
        'userId': userId,
      };
      await store.add(db, like); // Save to likes table
      print("Inserting like: $like");
    } catch (e) {
      print("Error inserting like: $e");
    }
  }

  Future<bool> hasUserLikedPost(int postId, String userId) async {
    try {
      final db = await database;
      final store = intMapStoreFactory.store('likes');
      final finder = Finder(
        filter: Filter.and([
          Filter.equals('postId', postId),
          Filter.equals('userId', userId),
        ]),
      );
      final records = await store.find(db, finder: finder);
      return records.isNotEmpty; // Return true if a like exists
    } catch (e) {
      print("Error checking if user liked post: $e");
      return false; // Return false on error
    }
  }

  Future<void> removeLike(int postId, String userId) async {
    try {
      final db = await database;
      final store = intMapStoreFactory.store('likes');
      final finder = Finder(
        filter: Filter.and([
          Filter.equals('postId', postId),
          Filter.equals('userId', userId),
        ]),
      );
      final records = await store.find(db, finder: finder);
      for (var record in records) {
        await store.record(record.key).delete(db); // Delete the like record
      }
      print("Removed like for postId: $postId by userId: $userId");
    } catch (e) {
      print("Error removing like: $e");
    }
  }
}