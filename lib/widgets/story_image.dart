import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/resources/firestore_methods.dart';
import 'package:insta_todo/screens/comments_screen.dart';
import 'package:insta_todo/screens/feed_screen.dart';
import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/screens/profile_screen.dart';
import 'package:insta_todo/screens/story_screen.dart';
import 'package:insta_todo/services/notifycation_services.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/widgets/like_animation.dart';
import 'package:insta_todo/widgets/post.dart';
import 'package:insta_todo/models/users.dart' as model;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/stories_editor.dart';

import '../models/story.dart';
import '../providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:insta_todo/models/story.dart' as modelStory;

class StoryImage extends StatefulWidget {
  final snap, fullSnap, index, lengthSnap;

  const StoryImage({
    Key? key,
    required this.snap,
    required this.fullSnap,
    required this.index,
    required this.lengthSnap,
  }) : super(key: key);

  @override
  State<StoryImage> createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User currentUser = _auth.currentUser!;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          widget.fullSnap.keys.elementAt(0) != currentUser.uid && widget.index == 0
              ? Container(
            child: Column(
              children: [
                Stack(
                  children: [
                        Container(
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: bgStoryColors)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StoriesEditor(
                                        giphyKey:
                                        '[HERE YOUR API KEY]',
                                        onDone: (uri) async {
                                          debugPrint(uri);
                                          File file = File(uri);
                                          Uint8List file1 = file.readAsBytesSync();
                                          postStory(
                                              userProvider.getUser.uid,
                                              userProvider.getUser.username,
                                              userProvider.getUser.photoUrl,
                                              file1);
                                        },
                                      )
                              ));
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2, color: bgWhite),
                                image: DecorationImage(
                                    image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/insta-todo.appspot.com/o/profilePics%2FMwgGwnL3XWSBnlwPR6VUfkeIVUQ2?alt=media&token=3e9a7d61-a3d4-47a4-b7c7-37c6b0d80824'),
                                    fit: BoxFit.cover)),
                              child: Icon(
                                Icons.add,
                                color: bgWhite,
                                size: 50,
                              ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Your story',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          )
          : Container(),
          Container(
            width: 80,
            child: Column(
              children: [
                Stack(
                  children: [
                    !widget.snap[0]['views'].contains(currentUser.uid) && widget.snap[0]['uid'] != currentUser.uid
                        ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: bgStoryColors)),
                      child: GestureDetector(
                        onTap: () {
                          List<Story> _stories = [];
                          widget.snap.forEach((element)  {
                            _stories.add(modelStory.Story.fromSnap(element));
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                              StoryScreen(stories: _stories, fullSnap: widget.fullSnap, index: widget.index, lengthSnap: widget.lengthSnap,),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 2, color: bgWhite),
                                image: DecorationImage(
                                    image: NetworkImage(widget.snap[0]['profImage'].toString()),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        List<Story> _stories = [];
                        widget.snap.forEach((element)  {
                          _stories.add(modelStory.Story.fromSnap(element));
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                StoryScreen(stories: _stories, fullSnap: widget.fullSnap, index: widget.index, lengthSnap: widget.lengthSnap,),
                          ),
                        );
                      },
                          child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: bgGrey),
                              image: DecorationImage(
                                  image: NetworkImage(widget.snap[0]['profImage'].toString()),
                                  fit: BoxFit.cover)),
                      ),
                    ),
                        ),
                    widget.snap[0]['uid'].toString() == FirebaseAuth.instance.currentUser!.uid
                        ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                        child: Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StoriesEditor(
                                              giphyKey:
                                              '[HERE YOUR API KEY]',
                                              onDone: (uri) async {
                                                debugPrint(uri);
                                                File file = File(uri);
                                                Uint8List file1 = file.readAsBytesSync();
                                                postStory(
                                                    userProvider.getUser.uid,
                                                    userProvider.getUser.username,
                                                    userProvider.getUser.photoUrl,
                                                    file1);
                                              },
                                            )));
                              },
                              child: Icon(
                                Icons.add,
                                color: bgWhite,
                                size: 1,
                              )),
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  widget.snap[0]['username'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void postStory(
      String uid, String username, String profImage, Uint8List _file) async {
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadStory(
        _file,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        notifyHelper.displayNotification(title: 'Story', body: 'Posted!');

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FeedScreen()),
        );
      } else {
        notifyHelper.displayNotification(title: 'Story', body: res);
      }
    } catch (err) {
      notifyHelper.displayNotification(title: 'Story', body: err.toString());
    }
  }
}
