import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_todo/models/post.dart';
import 'package:insta_todo/models/story.dart';
import 'package:insta_todo/resources/storage_methods.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User currentUser = FirebaseAuth.instance.currentUser!;

  Future<String> likePost(String postId, String postUrl, String postOwnerId, String name, String profImage,String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        bool isNotPostOwner = postOwnerId != currentUser.uid;
        String activityId = const Uuid().v1();
        if (isNotPostOwner) {
          _firestore
              .collection('users')
              .doc(postOwnerId)
              .collection('feedItems')
              .doc(activityId)
              .set({
            'type': 'like',
            'username': name,
            'userId': currentUser.uid,
            'userProfileImg': profImage,
            'postId': postId,
            'mediaUrl': postUrl,
            'timestamp': DateTime.now(),
          });
        }
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeStory(String storyId, String postUrl, String storyOwnerId, String name, String profImage,String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('stories').doc(storyId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('stories').doc(storyId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        bool isNotPostOwner = storyOwnerId != currentUser.uid;
        String activityId = const Uuid().v1();
        if (isNotPostOwner) {
          _firestore
              .collection('users')
              .doc(storyOwnerId)
              .collection('feedItems')
              .doc(activityId)
              .set({
            'type': 'likeStory',
            'username': name,
            'userId': currentUser.uid,
            'userProfileImg': profImage,
            'postId': storyId,
            'mediaUrl': postUrl,
            'timestamp': DateTime.now(),
          });
        }
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> viewStory(String storyId, String postUrl, String storyOwnerId, String name, String profImage,String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if(storyOwnerId != uid) {
        if (!likes.contains(uid)) {
          _firestore.collection('stories').doc(storyId).update({
            'views': FieldValue.arrayUnion([uid])
          });
          bool isNotPostOwner = storyOwnerId != currentUser.uid;
          String activityId = const Uuid().v1();
          if (isNotPostOwner) {
            _firestore
                .collection('users')
                .doc(storyOwnerId)
                .collection('feedItems')
                .doc(activityId)
                .set({
              'type': 'viewStory',
              'username': name,
              'userId': currentUser.uid,
              'userProfileImg': profImage,
              'postId': storyId,
              'mediaUrl': postUrl,
              'timestamp': DateTime.now(),
            });
          }
        }
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> uploadPost(String description, List<Uint8List> listFile, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      List<String> listPhotoUrl = [];
      await Future.wait(listFile.map((element) async {
        String photoUrl = await StorageMethods().uploadImageToStorage('posts', element, true);
        listPhotoUrl.add(photoUrl);
      }));

      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: listPhotoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadStory(Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('stories', file, true);
      String storyId = const Uuid().v1(); // creates unique id based on time
      Story story = Story(
        uid: uid,
        username: username,
        likes: [],
        views: [],
        storyId: storyId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('stories').doc(storyId).set(story.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
      String ownerId,
      String followId,
      String followUsername,
      String followUserPhoto,
      ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(ownerId).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([ownerId])
        });

        await _firestore.collection('users').doc(ownerId).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([ownerId])
        });

        await _firestore.collection('users').doc(ownerId).update({
          'following': FieldValue.arrayUnion([followId])
        });

        String activityId = const Uuid().v1();

        _firestore
            .collection('users')
            .doc(ownerId)
            .collection('feedItems')
            .doc(activityId)
            .set({
          'type': 'follow',
          'ownerId': ownerId,
          'username': followUsername,
          'userId': followId,
          'userProfileImg': followUserPhoto,
          'timestamp': DateTime.now(),
        });
      }


    } catch(e) {
      print(e.toString());
    }
  }

  // Post comment
  Future<String> postComment(String postId, String postUrl, String postOwnerId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        bool isNotPostOwner = postOwnerId != currentUser.uid;
        if (isNotPostOwner) {
          String activityId = const Uuid().v1();
          _firestore
              .collection('users')
              .doc(postOwnerId)
              .collection('feedItems')
              .doc(activityId)
              .set({
            'type': 'comment',
            'commentData': text,
            'timestamp': DateTime.now(),
            'postId': postId,
            'userId': currentUser.uid,
            'username': name,
            'userProfileImg': profilePic,
            'mediaUrl': postUrl,
          });
        }
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}