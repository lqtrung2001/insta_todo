import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_todo/models/activity.dart';
import 'package:insta_todo/screens/activity_feed.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/widgets/activity_item.dart';
import 'package:insta_todo/widgets/activity_tiles.dart';
import 'package:insta_todo/widgets/post_card.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    List<Activity> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(Activity.fromSnap(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    Size _screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.messenger_outline,
                color: primaryColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('feedItems')
                .orderBy('timestamp', descending: true)
                .limit(50)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => ActivityFeedItem(
                  snap: snapshot.data!.docs[index],
                ),
              );
            }));
  }
}
