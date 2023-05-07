import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_todo/models/story.dart';
import 'package:insta_todo/providers/user_provider.dart';
import 'package:insta_todo/resources/firestore_methods.dart';
import 'package:insta_todo/resources/storage_methods.dart';
import 'package:insta_todo/services/notifycation_services.dart';
import 'package:insta_todo/utils/colors.dart';
import 'package:insta_todo/utils/utils.dart';
import 'package:insta_todo/widgets/post_card.dart';
import 'package:insta_todo/utils/story_json.dart';
import 'package:insta_todo/widgets/story_image.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';
import 'package:collection/collection.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var notifyHelper;


  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    var beginningDate = DateTime.now();
    var newDate = beginningDate.subtract(Duration(days: 1));
    return Scaffold(
        appBar: width > 600
            ? null
            : AppBar(
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
        body: ListView(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('stories')
                        .where("datePublished",isGreaterThanOrEqualTo: newDate)
                        .orderBy("datePublished", descending: false)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final list = snapshot.data!.docs; // this is the List<ABC>
                      var mappedByUid =
                          groupBy(list, (entry) => entry['uid']);
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      int currentUserIndex = -1;
                      LinkedHashMap mapLinkedByUid = new LinkedHashMap<String, dynamic>();
                      if(mappedByUid.containsKey(uid)) {
                        List mapAsList = mappedByUid.keys.toList();
                        currentUserIndex = mapAsList.indexOf(uid);
                        mapLinkedByUid.putIfAbsent(uid, ()=>mappedByUid[mappedByUid.keys.elementAt(currentUserIndex)]);
                        mappedByUid.remove(uid);
                      }
                      for (final item in mappedByUid.entries) {
                        mapLinkedByUid.putIfAbsent(item.key, () => item.value);
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: mapLinkedByUid.length <= 0 ? 1 : mapLinkedByUid.length,
                          itemBuilder: (ctx, index) {
                            if(mapLinkedByUid.length <=0) {
                              return Container(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(colors: bgStoryColors)),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoriesEditor(
                                                            giphyKey:
                                                            '[HERE YOUR API KEY]',
                                                            onDone: (uri) async {
                                                              debugPrint(uri);
                                                              File file = File(uri);
                                                              Uint8List file1 = file.readAsBytesSync();
                                                              postStory(
                                                                  userProvider.getUser.uid,
                                                                  userProvider.getUser.username,
                                                                  userProvider.getUser.photoUrl,
                                                                  file1);
                                                            },
                                                          )
                                                  ));
                                              // Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Container(
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(width: 2, color: bgWhite),
                                                    image: DecorationImage(
                                                        image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/insta-todo.appspot.com/o/profilePics%2FMwgGwnL3XWSBnlwPR6VUfkeIVUQ2?alt=media&token=3e9a7d61-a3d4-47a4-b7c7-37c6b0d80824'),
                                                        fit: BoxFit.cover)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: bgWhite,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Your story',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            }
                            String key = mapLinkedByUid.keys.elementAt(index);
                            return Container(
                              child: StoryImage(
                                snap: mapLinkedByUid[key],
                                fullSnap: mapLinkedByUid,
                                index: index,
                                lengthSnap: mapLinkedByUid.length,
                              ),
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          SingleChildScrollView(
            physics: ScrollPhysics(),
            padding: EdgeInsets.only(top: 5, left: 5, right: 5),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > 600 ? width * 0.3 : 0,
                          vertical: width > 600 ? 15 : 0,
                        ),
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ]));
  }

  void postStory(
      String uid, String username, String profImage, Uint8List _file) async {
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadStory(
        _file,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        notifyHelper.displayNotification(title: 'Story', body: 'Posted!');

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FeedScreen()),
        );
      } else {
        notifyHelper.displayNotification(title: 'Story', body: res);
      }
    } catch (err) {
      notifyHelper.displayNotification(title: 'Story', body: err.toString());
    }
  }
}
