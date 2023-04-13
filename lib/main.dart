import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insta_todo/providers/user_provider.dart';
import 'package:insta_todo/responsive/mobile_screen_layout.dart';
import 'package:insta_todo/responsive/responsive_layout.dart';
import 'package:insta_todo/screens/comments_screen.dart';
import 'package:insta_todo/screens/search_screen.dart';
import 'package:insta_todo/utils/colors.dart';

import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/screens/signup_screen.dart';
import 'package:insta_todo/screens/profile_screen.dart';
import 'package:insta_todo/screens/search_screen.dart';
import 'package:insta_todo/widgets/post.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // initialise app based on platform- web or mobile
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBwNfxkqnj0Kmc9XpbbYS0YCCP-XCm84DQ",
        appId: "1:999053983827:android:e2a42cbf9fc6651ea386a6",
        messagingSenderId: "999053983827",
        projectId: "insta-todo",
        storageBucket: 'insta-todo.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
