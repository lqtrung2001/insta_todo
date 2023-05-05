import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/screens/post_screen.dart';
import 'package:insta_todo/screens/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;


class ActivityFeedItem extends StatelessWidget {
  final snap;

  var activityItemText;
  var mediaPreview;
  ActivityFeedItem({
    required this.snap,
  });


  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostScreen(
            postId: snap.data()['postId'],
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
            backgroundImage: CachedNetworkImageProvider(snap.data()['userProfileImg']),
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