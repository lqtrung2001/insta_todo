// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:insta_todo/screens/comments_screen.dart';
// import 'package:insta_todo/screens/profile_screen.dart';
// import 'package:insta_todo/utils/colors.dart';
//
// class PostScreen extends StatelessWidget {
//   // This widget is the root of your application.
//   String userImage,
//       username,
//       caption,
//       timeAgo,
//       imageUrl,
//       likes,
//       comments,
//       shares,
//       profileImage;
//
//   PostScreen(
//       {Key? key,
//       required this.userImage,
//       required this.username,
//       required this.caption,
//       required this.timeAgo,
//       required this.imageUrl,
//       required this.likes,
//       required this.comments,
//       required this.shares,
//       required this.profileImage});
//
//   @override
//   Widget build(BuildContext context) {
//     return PostScreenPage(
//       userImage: this.userImage,
//       username: this.username,
//       caption: this.caption,
//       timeAgo: this.timeAgo,
//       imageUrl: this.imageUrl,
//       likes: this.likes,
//       comments: this.comments,
//       shares: this.shares,
//       profileImage: this.profileImage,
//     );
//   }
// }
//
// class PostScreenPage extends StatefulWidget {
//   String userImage,
//       username,
//       caption,
//       timeAgo,
//       imageUrl,
//       likes,
//       comments,
//       shares,
//       profileImage;
//
//   PostScreenPage(
//       {Key? key,
//       required this.userImage,
//       required this.username,
//       required this.caption,
//       required this.timeAgo,
//       required this.imageUrl,
//       required this.likes,
//       required this.comments,
//       required this.shares,
//       required this.profileImage});
//
//   @override
//   _PostScreenState createState() => _PostScreenState();
// }
//
// class _PostScreenState extends State<PostScreenPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: mobileBackgroundColor,
//           title: SvgPicture.asset(
//             'assets/ic_instagram.svg',
//             color: primaryColor,
//             height: 32,
//           ),
//           centerTitle: false,
//         ),
//         body: Card(
//           margin: EdgeInsets.symmetric(
//             vertical: 5.0,
//             horizontal: 0.0,
//           ),
//           elevation: 0.0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       _PostHeader(
//                         profileImage: widget.userImage,
//                         username: widget.username,
//                         timeAgo: widget.timeAgo,
//                       ),
//                       const SizedBox(height: 4.0),
//                       Text(widget.caption),
//                       widget.imageUrl != null
//                           ? const SizedBox.shrink()
//                           : const SizedBox(height: 6.0),
//                     ],
//                   ),
//                 ),
//                 widget.imageUrl != null
//                     ? Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Image.network(widget.imageUrl),
//                       )
//                     : const SizedBox.shrink(),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: _PostStats(
//                     likes: widget.likes,
//                     comments: widget.comments,
//                     share: widget.shares,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// class _PostHeader extends StatelessWidget {
//   final String profileImage;
//   final String username;
//   final String timeAgo;
//
//   const _PostHeader({
//     Key? key,
//     required this.profileImage,
//     required this.username,
//     required this.timeAgo,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         InkWell(
//           child: _AvatarImage(
//             profileAvatarImage: profileImage,
//           ),
//           onTap: () => Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => ProfileScreen(user_id: '1')),
//           ),
//         ),
//
//         const SizedBox(width: 8.0),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 username,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     '${timeAgo} • ',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12.0,
//                     ),
//                   ),
//                   Icon(
//                     Icons.public,
//                     color: Colors.grey[600],
//                     size: 12.0,
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.more_horiz),
//           onPressed: () => print('More'),
//         ),
//       ],
//     );
//   }
// }
//
// class _PostStats extends StatelessWidget {
//   final String likes, comments, share;
//
//   const _PostStats({
//     Key? key,
//     required this.likes,
//     required this.comments,
//     required this.share,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4.0),
//               decoration: BoxDecoration(
//                 color: Colors.white38,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.favorite,
//                 size: 15.0,
//                 color: Colors.pink,
//               ),
//             ),
//             const SizedBox(width: 4.0),
//             Expanded(
//               child: Text(
//                 '${likes}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ),
//             Text(
//               '${comments} Comments',
//               style: TextStyle(
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(width: 8.0),
//             Text(
//               '${share} Shares',
//               style: TextStyle(
//                 color: Colors.grey[600],
//               ),
//             )
//           ],
//         ),
//         const Divider(),
//         Row(
//           children: [
//             _PostButton(
//               icon: Icon(
//                 Icons.favorite,
//                 color: Colors.grey[600],
//                 size: 20.0,
//               ),
//               label: 'Like',
//               onTap: () => print('Like'),
//             ),
//             _PostButton(
//               icon: Icon(
//                 Icons.comment_outlined,
//                 color: Colors.grey[600],
//                 size: 20.0,
//               ),
//               label: 'Comment',
//               onTap: () => Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => CommentsScreen(postId: null,)),
//               ),
//             ),
//             _PostButton(
//               icon: Icon(
//                 Icons.share,
//                 color: Colors.grey[600],
//                 size: 25.0,
//               ),
//               label: 'Share',
//               onTap: () => print('Share'),
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class _PostButton extends StatelessWidget {
//   final Icon icon;
//   final String label;
//   final Function onTap;
//
//   const _PostButton({
//     Key? key,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Material(
//         color: Colors.white,
//         child: InkWell(
//           onTap: () => Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => CommentsScreen(postId: 1,)),
//           ),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             height: 25.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 icon,
//                 const SizedBox(width: 4.0),
//                 Text(label),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _AvatarImage extends StatelessWidget {
//   final String profileAvatarImage;
//
//   const _AvatarImage({
//     Key? key,
//     required this.profileAvatarImage,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
//       child: Stack(children: [
//         CircleAvatar(
//           radius: 20.0,
//           backgroundColor: Colors.grey[200],
//           backgroundImage: NetworkImage(profileAvatarImage != null
//               ? profileAvatarImage
//               : "https://qph.fs.quoracdn.net/main-qimg-11ef692748351829b4629683eff21100.webp"),
//         ),
//       ]),
//     );
//   }
// }
