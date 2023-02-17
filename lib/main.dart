import 'package:flutter/material.dart';
import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/utils/colors.dart';

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
      home: LoginScreen(),
    );
  }
}
