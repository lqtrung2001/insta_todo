import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_todo/resources/auth_methods.dart';
import 'package:insta_todo/resources/firestore_methods.dart';
import 'package:insta_todo/screens/login_screen.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String user_id;

  const ProfileScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  var userData = {};
  int followers = 0;
  int following = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('username'),
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
                        backgroundImage: NetworkImage(
                            'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&quality=85&auto=format&fit=max&s=a52bbe202f57ac0f5ff7f47166906403'
                        ),
                        radius: 40,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStateColum(20, "posts"),
                                buildStateColum(20, "flowers"),
                                buildStateColum(20, "flowing"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                    // widget.user_id
                                    FirebaseAuth.instance.currentUser!.uid
                                    ? FollowButton(
                                  text: 'Sign Out',
                                  backroundColor:
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
                                  backroundColor: Colors.white,
                                  textColor: Colors.black,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await FireStoreMethods()
                                        .followUser(
                                      FirebaseAuth.instance
                                          .currentUser!.uid,
                                      userData['uid'],
                                    );

                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  },
                                )
                                    : FollowButton(
                                  text: 'Follow',
                                  backroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  borderColor: Colors.blue,
                                  function: () async {
                                    await FireStoreMethods()
                                        .followUser(
                                      FirebaseAuth.instance
                                          .currentUser!.uid,
                                      userData['uid'],
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
                    child: Text('username', style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 1),
                    child: Text('Description || Le Thi Ngoc Diem',),
                  ),
                ],
              )
          ),

          const Divider(),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1.5,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Container(
                child: Image(
                  image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png'),
                  fit: BoxFit.cover,
                ),
              );
            },
          )
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
