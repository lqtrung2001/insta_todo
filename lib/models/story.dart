import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String uid;
  final String username;
  final String profImage;
  final likes;
  final views;
  final String storyId;
  final DateTime datePublished;
  final String postUrl;

  const Story(
      {
        required this.uid,
        required this.username,
        required this.likes,
        required this.views,
        required this.storyId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
      });

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Story(
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        views: snapshot["views"],
        storyId: snapshot["storyId"],
        datePublished: (snapshot["datePublished"]as Timestamp).toDate(),
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "likes": likes,
    "views": views,
    "username": username,
    "storyId": storyId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage
  };
}