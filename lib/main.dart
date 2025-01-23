import 'dart:io';

import 'package:demo_flutter/auth/LoginPage.dart';
import 'package:demo_flutter/auth/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:share_plus/share_plus.dart';

import 'MePage.dart';
import 'SettingPage.dart';
import 'dataModel.dart';
import 'database_helper.dart';
import 'firebase_options.dart';
import 'notification.dart';
import 'post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  late DatabaseFactory databaseFactory;
  if (kIsWeb) {
    databaseFactory = databaseFactoryWeb;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Journaling',
      theme: ThemeData(
        primaryColor: const Color(0xFF1877F2),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  List<String> comments = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _showCommentDialog() {
    final TextEditingController commentController = TextEditingController();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to add a comment.')),
      );
      return;
    }

    final String username =
        currentUser.displayName ?? "Anonymous"; // Get username

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Comment'),
          content: SizedBox(
            width: double.maxFinite, // Set width for the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use min to avoid overflow
              children: [
                TextField(
                  controller: commentController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your comment'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String commentText = commentController.text;
                if (commentText.isNotEmpty) {
                  setState(() {
                    comments.add('$username: $commentText');
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Comment cannot be empty')),
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

  int currentIndex = 0;
  List<DataModel> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      print("Loading posts...");
      List<Map<String, dynamic>> fetchedPosts =
          await DatabaseHelper().getAllPosts();
      print("Fetched posts: $fetchedPosts");

      List<DataModel> postsList =
          fetchedPosts.map((post) => DataModel.fromJson(post)).toList();

      setState(() {
        posts = postsList;
      });
    } catch (e) {
      print("Error loading posts: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: ClipOval(
            child: Image.asset(
              'images/zion.jpg',
              width: 40.0,
              height: 40.0,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(),
              ),
            );
          },
        ),
        title: const Text(
          "Journal Your Day",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
          IconButton(
            icon: Icon(Icons.notification_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Center(
                child: Image.asset(
                  'images/image.jpg',
                ),
              ),
            ),
            ...posts
                .map((post) => _buildPost(
                      post.title ?? '',
                      post.caption ?? '',
                      post.image ?? '',
                      post.id ?? 0,
                    ))
                .toList(),
            _buildPost(
                "How to heal from your trauma ",
                "emotional Release: Writing down your emotions helps unload heavy feelings, reducing anxiety and emotional tension. It's like having a private conversation where you can be completely honest.Understanding Triggers:Journaling allows you to track events, emotions, or memories that trigger your trauma. This helps you identify patterns and develop coping mechanisms. Reframing Negative Thoughts:By reflecting on your experiences, you can challenge distorted beliefs or self-blame associated with the trauma and replace them with more compassionate perspectives.Empowering Your Voice: Trauma often makes people feel voiceless. Journaling gives you a sense of agency by allowing you to narrate your story and reclaim control over your life.Memory Processing Writing about traumatic memories in a safe and structured way can help organize chaotic thoughts, making them less overwhelming over time. Describe how you want to feel, act, and live.",
                "images/jornal.png",
                12),
            _buildPost(
                "Benefits of Journaling for Trauma Recovery",
                " Stress Reduction: Journaling lowers cortisol (the stress hormone), promoting calmness and mental clarity.Improved Sleep: Writing before bed can help unload racing thoughts, improving sleep quality.Emotional Regulation: Regular journaling helps you process emotions rather than suppressing or ignoring them.Self-Awareness: Deep introspection helps you understand your needs, values, and boundaries.Empowerment: Journaling is a self-led practice, reminding you that you have the power to heal.",
                "images/images.jpg",
                12),
            _buildPost(
                "Morning journal ideas",
                " Start Small: Write for 5 to 10 minutes daily. Don't pressure yourself to dive deep immediately.Find a Safe Space: Ensure privacy so you feel safe expressing yourself freely.Use “I” Statements: Focus on your personal experience and emotions.Be Honest: Let go of the need to filter your feelings—no one else will read it.End Positively: Conclude each session with something uplifting, like gratitude or a comforting thought.",
                "images/moring.jpg",
                12),
            _buildPost(
                "Self - Reflection",
                "i miss the day i love myself and respect people i miss the day i respect people oh dear lord in my whole life journey i have always asked nothing but to be a good person why don't you listen to me? or are my prayers not enough? dear lord whats left to lose now? dear lord what are you trying to show me? if i can't live with people with peace and respect the for who they are help them in every aspect then when will i learn? being hated where ever i go, being the bad girl who can't control her emotion dear lord if you are real and listen to me then why aren't you listening to my prayers? what did i do? 23 years on this earth and i have always been that annoying girl who make peoples life miserable. ughhhhhh idk please just help me dear brain, you're all i got in this cruel world",
                "images/self3.jpg",
                12),
            _buildPost(
                "A little bit intro to Self-Concept",
                " Self-concept refers to the understanding and perception we have of ourselves, encompassing our beliefs, values, and identity. It is shaped by our experiences, interactions, and the feedback we receive from others. Self-concept influences how we see ourselves in various roles—such as a friend, professional, or family member—and affects our self-esteem and overall well-being.A positive self-concept fosters confidence and resilience, allowing us to pursue our goals and navigate challenges with a sense of purpose. Conversely, a negative self-concept can lead to self-doubt and hinder personal growth.",
                "images/self4.png",
                12),
            _buildPost(
                "Self-Esteem",
                "Self-esteem refers to the overall value we place on ourselves and our self-worth. It encompasses how we perceive our abilities, qualities, and potential. High self-esteem generally leads to a positive self-image, promoting confidence and a sense of belonging, while low self-esteem can result in self-doubt, insecurity, and negative self-talk.Self-esteem is influenced by various factors, including our upbringing, experiences, and social interactions. Positive reinforcement from family, friends, and accomplishments can boost our self-esteem, while criticism, failure, or comparison to others can diminish it.",
                "images/self2.png",
                12),
            _buildPost(
                "Self-Love and the Journey",
                "Self-love is a transformative journey of acceptance and compassion towards oneself. It begins with recognizing our inherent worth, appreciating our unique qualities, and embracing our imperfections. This journey often involves overcoming self-doubt, letting go of negative self-talk, and prioritizing our needs and well-being.As we cultivate self-love, we learn to set healthy boundaries, practice forgiveness, and nurture our mental and emotional health. It's a continuous process that encourages growth, resilience, and the ability to celebrate our achievements—big or small. Ultimately, self-love empowers us to live authentically and fosters deeper connections with others, creating a more fulfilling and joyful life.",
                "images/self1.jpeg",
                12),
            _buildPost(
                "A guide to Self-Awareness",
                "Self-awareness is the ability to introspect and understand our thoughts, emotions, and behaviors. It involves recognizing our strengths and weaknesses, which allows us to make informed decisions and engage with the world more authentically. This journey often starts with reflection—taking time to assess our feelings, motivations, and reactions to various situations.As we develop self-awareness, we become more attuned to how our actions impact ourselves and others. This heightened awareness fosters emotional intelligence, enabling us to manage our emotions and respond to challenges more effectively. It also encourages personal growth, as we begin to identify areas for improvement and set meaningful goals.Ultimately, self-awareness is a powerful tool for enhancing relationships, promoting self-acceptance, and leading a more intentional and fulfilling life. It empowers us to navigate our experiences with clarity and purpose.",
                "images/self5.png",
                11),
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
        currentIndex: currentIndex,
        onTap: (int index) {
          if (index == 0) {
            setState(() {
              currentIndex = index;
            });
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingPage(
                  onPostCreated: (imagePath, title, caption) {},
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MePage()));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostManager(
                onPostCreated: (imagePath, title, caption) {
                  setState(() {
                    posts.add(DataModel(
                      title: title,
                      caption: caption,
                      image: imagePath, // Change key to 'image'
                    ));
                  });

                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPost(
      String title, String caption, String imagePath, int postId) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 5),
            Text(caption),
            const SizedBox(height: 10),
            kIsWeb
                ? Image.network(imagePath,
                    fit: BoxFit.cover, width: double.infinity)
                : Image.file(File(imagePath),
                    fit: BoxFit.cover, width: double.infinity),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    if (currentUser != null) {
                      final userId = currentUser.uid;
                      final hasLiked = await _databaseHelper.hasUserLikedPost(
                          postId, userId);

                      if (!hasLiked) {
                        await _databaseHelper.insertLike(postId, userId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('You liked the post!')),
                        );
                      } else {
                        await _databaseHelper.removeLike(postId, userId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('You unliked the post!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('You must be logged in to like a post.')),
                      );
                    }
                    count++;
                  },
                  icon: const Icon(Icons.thumb_up, size: 20),
                  label: Text(
                    "Like:  $count",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showCommentDialog();
                  },
                  icon: const Icon(Icons.comment, size: 20),
                  label: const Text("Comment", style: TextStyle(fontSize: 20)),
                ),
                TextButton.icon(
                  onPressed: () {
                    final String textToShare = "Check out this amazing post!";
                    Share.share(textToShare);
                  },
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text("Share", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
