import 'package:flutter/material.dart';
import 'package:insta_todo/responsive/mobile_screen_layout.dart';
import 'package:insta_todo/screens/search_screen.dart';
import 'package:insta_todo/utils/colors.dart';

import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/screens/signup_screen.dart';
import 'package:insta_todo/screens/profile_screen.dart';
import 'package:insta_todo/screens/search_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Todo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: MobileScreenLayout(),
    );
  }
}
