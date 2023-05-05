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
      body: Container(
        height: _screen.height,
        width: _screen.width,
        color: Theme.of(context).primaryColorDark,
        child: ListView(
          children: <Widget>[
            ListTile(
                leading: Text('This Week1',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16))),
            followActivityTile(
                context: context,
                followerUsername: 'tenzin_choekyi',
                followerImageUrl: Utils.getRandomImageUrl(),
                isFollowed: false),
            commnetActivityTIle(
                isMention: true,
                otherUsername: 'ttruselph',
                otherUserProfileImageUrl: Utils.getRandomImageUrl(),
                comment: 'jpt journalist n jpt reporting',
                commentedOnMediaUrl: Utils.getRandomImageUrl()),
            followActivityTile(
                context: context,
                followerUsername: 'gyalmo20',
                followerImageUrl: Utils.getRandomImageUrl()),
            commnetActivityTIle(
                isMention: true,
                comment: '😂',
                otherUsername: 'codepower.io',
                otherUserProfileImageUrl: Utils.getRandomImageUrl(),
                commentedOnMediaUrl: Utils.getRandomImageUrl()),
            commnetActivityTIle(
                isMention: false,
                comment:
                'Haha. One that fools around a lot but gets there workd done some how. 😂😂😂',
                otherUsername: 'codepower.io',
                otherUserProfileImageUrl: Utils.getRandomImageUrl(),
                commentedOnMediaUrl: Utils.getRandomImageUrl()),
            Divider(color: Colors.grey[500]),
            ListTile(
                leading: Text('This Month',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16))),
            likedOnPost(
              likedUsernames:
              List.generate(100000, (index) => 'apple${index.toString()}'),
              postUrl: Utils.getRandomImageUrl(),
              likedUserImageUrls:
              List.generate(2, (index) => Utils.getRandomImageUrl()),
            ),
            followActivityTile(
                context: context,
                followerUsername: 'himani_mudgil',
                followerImageUrl: Utils.getRandomImageUrl(),
                isFollowed: true),
            followActivityTile(
                context: context,
                followerUsername: 'ngawang_94',
                followerImageUrl: Utils.getRandomImageUrl(),
                isFollowed: true),
            followActivityTile(
                context: context,
                followerUsername: 'thokmey_tenzi',
                followerImageUrl: Utils.getRandomImageUrl()),
          ],
        ),
      ),
    );
  }
}