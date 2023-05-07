import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/resources/auth_methods.dart';
import 'package:insta_todo/resources/firestore_methods.dart';
import 'package:insta_todo/screens/following_screen.dart';
import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/screens/post_screen.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/widgets/follow_button.dart';
import 'package:insta_todo/widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String user_id;

  const ProfileScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  var userData = {};
  var currentUserData = {};
  var postData = {};
  int followers = 0;
  int following = 0;
  int postLen = 0;
  bool isLoading = false;

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
      var currentUserSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.user_id)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      currentUserData = currentUserSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userData['photoUrl']),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () {},
                                          child: buildStateColum(
                                              postLen, "posts")),
                                      InkWell(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowingScreen(
                                                          user_id:
                                                              userData['uid']
                                                                  .toString(),
                                                          isFollower: true,
                                                          current_user_id:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                        )),
                                              ),
                                          child: buildStateColum(
                                              followers, "flowers")),
                                      InkWell(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowingScreen(
                                                          user_id:
                                                              userData['uid']
                                                                  .toString(),
                                                          isFollower: false,
                                                          current_user_id:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                        )),
                                              ),
                                          child: buildStateColum(
                                              following, "flowing")),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              // widget.user_id
                                              userData['uid']
                                          ? FollowButton(
                                              text: 'Sign Out',
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              textColor: primaryColor,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                await AuthMethods().signOut();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: 'Unfollow',
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                      currentUserData[
                                                          'username'],
                                                      currentUserData[
                                                          'photoUrl'],
                                                    );

                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  text: 'Follow',
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  borderColor: Colors.blue,
                                                  function: () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                      currentUserData[
                                                          'username'],
                                                      currentUserData[
                                                          'photoUrl'],
                                                    );

                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Bio',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            userData['bio'],
                          ),
                        ),
                      ],
                    )),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.user_id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: postLen == 0 ? 1 : postLen,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          if (postLen <= 0) {
                            return Container(
                                child: Text(
                              'No post!!!',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ));
                          } else {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            List listPostUrl = snap['postUrl'];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostScreen(snap: snap)
                              )),
                              child: Container(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: listPostUrl.length > 1 ? Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Container(),
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(listPostUrl[0]),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    })
              ],
            ),
          );
  }

  Column buildStateColum(int num, String lable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          lable,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
