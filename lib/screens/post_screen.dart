import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/models/post.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/widgets/post_card.dart';

class PostScreen extends StatelessWidget {
  final String postId;

  PostScreen({
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                'Activity',
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: PostCard(
                    snap: snapshot.data!,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}