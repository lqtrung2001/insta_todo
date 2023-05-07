import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/models/story.dart';
import 'package:insta_todo/screens/post_screen.dart';
import 'package:insta_todo/screens/profile_screen.dart';
import 'package:insta_todo/screens/story_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:insta_todo/models/story.dart' as modelStory;

class ActivityFeedItem extends StatelessWidget {
  final snap;

  var activityItemText;
  var mediaPreview;

  ActivityFeedItem({
    required this.snap,
  });

  showPost(context) async {
    DocumentSnapshot snapPost = await FirebaseFirestore.instance
        .collection('posts')
        .doc(snap.data()['postId'])
        .get();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostScreen(
                snap: snapPost,
              )),
    );
  }

  showStory(context) async {
    QuerySnapshot snapPost = await FirebaseFirestore.instance
        .collection('stories')
        .where('storyId', isEqualTo: snap.data()['postId'])
        .get();
    var mappedByUid = new Map();
    mappedByUid[snap.data()['userId']] = snapPost.docs;
    List<Story> _stories = [];
    mappedByUid[snap.data()['userId']].forEach((element)  {
      _stories.add(modelStory.Story.fromSnap(element));
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StoryScreen(
            stories: _stories, fullSnap: mappedByUid, index: 0, lengthSnap: mappedByUid.length,
          )),
    );
  }

  configureMediaPreview(context) {
    String type = snap.data()['type'];
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(snap.data()['mediaUrl']),
              )),
            ),
          ),
        ),
      );
    } else if (type == 'viewStory' || type == 'likeStory') {
      mediaPreview = GestureDetector(
        onTap: () => showStory(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(snap.data()['mediaUrl']),
              )),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = 'liked your post';
    } else if (type == 'follow') {
      activityItemText = 'is following you';
    } else if (type == 'comment') {
      var commentData = snap.data()['commentData'];
      activityItemText = 'replied: $commentData';
    } else if (type == 'viewStory') {
      activityItemText = 'viewed your story';
    } else if (type == 'likeStory') {
      activityItemText = 'liked your story';
    } else {
      activityItemText = 'Error: Unknown type "$type"';
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => ProfileScreen(user_id: snap.data()['userId']),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: snap.data()['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $activityItemText',
                  ),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(snap.data()['userProfileImg']),
          ),
          subtitle: Text(
            timeago.format(snap.data()['timestamp'].toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
