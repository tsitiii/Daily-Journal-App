// import 'package:demo_flutter/dataModel.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dataModel.dart';

// class Db{
//  Future <Database> initDb() async{
//     String path = await getDatabasesPath();
//     return openDatabase(join(path, 'posts.db'), onCreate: (db, version) async {
//       await db.execute('''
//         CREATE TABLE posts(
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           title TEXT,
//           caption TEXT,
//           image TEXT,
//           userId TEXT
//         )
//       ''');
//     }, version: 1);
//  }

// Future<bool> insertPost(DataModel) async{
//   final Database db = await initDb();
//   await db.insert('posts', DataModel.toJson());
//   return true;
// }







//             // _buildPost(
//             //   "Self - Reflection",
//             //   "i miss the day i love myself and respect people i miss the day i respect people oh dear lord in my whole life journey i have always asked nothing but to be a good person why don't you listen to me? or are my prayers not enough? dear lord whats left to lose now? dear lord what are you trying to show me? if i can't live with people with peace and respect the for who they are help them in every aspect then when will i learn? being hated where ever i go, being the bad girl who can't control her emotion dear lord if you are real and listen to me then why aren't you listening to my prayers? what did i do? 23 years on this earth and i have always been that annoying girl who make peoples life miserable. ughhhhhh idk please just help me dear brain, you're all i got in this cruel world",
//             //   "images/self3.jpg",
//             // ),
//             // _buildPost(
//             //   "A little bit intro to Self-Concept",
//             //   " Self-concept refers to the understanding and perception we have of ourselves, encompassing our beliefs, values, and identity. It is shaped by our experiences, interactions, and the feedback we receive from others. Self-concept influences how we see ourselves in various roles—such as a friend, professional, or family member—and affects our self-esteem and overall well-being.A positive self-concept fosters confidence and resilience, allowing us to pursue our goals and navigate challenges with a sense of purpose. Conversely, a negative self-concept can lead to self-doubt and hinder personal growth.",
//             //   "images/self4.png",
//             // ),
//             // _buildPost(
//             //   "Self-Esteem",
//             //   "Self-esteem refers to the overall value we place on ourselves and our self-worth. It encompasses how we perceive our abilities, qualities, and potential. High self-esteem generally leads to a positive self-image, promoting confidence and a sense of belonging, while low self-esteem can result in self-doubt, insecurity, and negative self-talk.Self-esteem is influenced by various factors, including our upbringing, experiences, and social interactions. Positive reinforcement from family, friends, and accomplishments can boost our self-esteem, while criticism, failure, or comparison to others can diminish it.",
//             //   "images/self2.png",
//             // ),
//             // _buildPost(
//             //   "Self-Love and the Journey",
//             //   "Self-love is a transformative journey of acceptance and compassion towards oneself. It begins with recognizing our inherent worth, appreciating our unique qualities, and embracing our imperfections. This journey often involves overcoming self-doubt, letting go of negative self-talk, and prioritizing our needs and well-being.As we cultivate self-love, we learn to set healthy boundaries, practice forgiveness, and nurture our mental and emotional health. It's a continuous process that encourages growth, resilience, and the ability to celebrate our achievements—big or small. Ultimately, self-love empowers us to live authentically and fosters deeper connections with others, creating a more fulfilling and joyful life.",
//             //   "images/self1.jpeg",
//             // ),
//             // _buildPost(
//             //   "A guide to Self-Awareness",
//             //   "Self-awareness is the ability to introspect and understand our thoughts, emotions, and behaviors. It involves recognizing our strengths and weaknesses, which allows us to make informed decisions and engage with the world more authentically. This journey often starts with reflection—taking time to assess our feelings, motivations, and reactions to various situations.As we develop self-awareness, we become more attuned to how our actions impact ourselves and others. This heightened awareness fosters emotional intelligence, enabling us to manage our emotions and respond to challenges more effectively. It also encourages personal growth, as we begin to identify areas for improvement and set meaningful goals.Ultimately, self-awareness is a powerful tool for enhancing relationships, promoting self-acceptance, and leading a more intentional and fulfilling life. It empowers us to navigate our experiences with clarity and purpose.",
//             //   "images/self5.png",
//             // ),