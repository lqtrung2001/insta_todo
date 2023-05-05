import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  const Activity(
      { required this.username,
        required this.userId,
        required this.type,
        required this.mediaUrl,
        required this.postId,
        required this.userProfileImg,
        required this.commentData,
        required this.timestamp});

  static Activity fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Activity(
      username: snapshot['username'],
      userId: snapshot['userId'],
      type: snapshot['type'],
      postId: snapshot['postId'],
      userProfileImg: snapshot['userProfileImg'],
      commentData: snapshot['commentData'],
      timestamp: snapshot['timestamp'],
      mediaUrl: snapshot['mediaUrl'],
    );
  }
}