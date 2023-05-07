import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_todo/resources/firestore_methods.dart';
import 'package:insta_todo/screens/comments_screen.dart';
import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/screens/profile_screen.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/widgets/like_animation.dart';
import 'package:insta_todo/widgets/post.dart';
import 'package:insta_todo/models/users.dart' as model;
import 'package:insta_todo/widgets/post_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'package:get/get.dart';

import 'package:carousel_slider/carousel_slider.dart';

class PostScreen extends StatefulWidget {
  final snap;

  const PostScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    List imagesList = widget.snap['postUrl'];

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
        body: PostCard(snap: widget.snap,)
    );
  }
}
