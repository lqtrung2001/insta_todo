import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_todo/models/users.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/resources/firestore_methods.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/models/users.dart' as model;

class FollowingScreen extends StatefulWidget {
  final String user_id;
  final bool isFollower;
  final String current_user_id;

  const FollowingScreen(
      {Key? key,
      required this.user_id,
      required this.isFollower,
      required this.current_user_id})
      : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with TickerProviderStateMixin {
  List<User> _selectedUsers = [];
  bool isLoading = false;
  List listFollowId = [];
  var userData = {};
  List<User> _users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user_id)
          .get();
      userData = userSnap.data()!;
      if (widget.isFollower) {
        listFollowId = userSnap.data()!['followers'];
      } else {
        listFollowId = userSnap.data()!['following'];
      }
      listFollowId.forEach((element) async {
        var userDetail = await FirebaseFirestore.instance
            .collection('users')
            .doc(element)
            .get();
        _users.add(model.User.fromSnap(userDetail));
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.isFollower ? 'Follower' : 'Following',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(right: 20, left: 20),
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return userComponent(user: _users[index]);
            },
          )),
    );
  }

  userComponent({required User user}) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(user.photoUrl),
                )),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.username,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 5,
              ),
              Text(user.username, style: TextStyle(color: Colors.grey[600])),
            ])
          ]),
          Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffeeeeee)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: MaterialButton(
                elevation: 0,
                color: user.followers.contains(widget.current_user_id)
                    ? Color(0xffeeeeee)
                    : Color(0xffffff),
                onPressed: () async {
                  await FireStoreMethods().followUser(
                    widget.current_user_id,
                    user.uid,
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                    user.followers.contains(widget.current_user_id)
                        ? 'Unfollow'
                        : 'Follow',
                    style: TextStyle(color: Colors.black)),
              ))
        ],
      ),
    );
  }
}
