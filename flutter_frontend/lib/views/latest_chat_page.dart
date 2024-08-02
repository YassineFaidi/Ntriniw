// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:ntrriniw_v0/pages/chat_page.dart';

// class LatestChatPage extends StatefulWidget {
//   const LatestChatPage({super.key});

//   @override
//   State<LatestChatPage> createState() => _LatestChatPageState();
// }

// class _LatestChatPageState extends State<LatestChatPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Users List"),
//       ),
//       body: _buildUserList(),
//     );
//   }

//   Widget _buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("users").snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text("Error"));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return ListView(
//           children: snapshot.data!.docs
//               .map<Widget>((doc) => _buildUserListItem(doc))
//               .toList(),
//         );
//       },
//     );
//   }

//   Widget _buildUserListItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

//     if (_auth.currentUser!.email != data["email"]) {
//       return UserListItem(
//         email: data["email"],
//         uid: data["uid"],
//         profileImg: data["profileImg"],
//         username: data["username"],
//       );
//     } else {
//       return Container();
//     }
//   }
// }

// class UserListItem extends StatefulWidget {
//   final String email;
//   final String uid;
//   final String profileImg;
//   final String username;

//   const UserListItem({
//     required this.email,
//     required this.uid,
//     required this.profileImg,
//     required this.username,
//     super.key,
//   });

//   @override
//   State<UserListItem> createState() => _UserListItemState();
// }

// class _UserListItemState extends State<UserListItem> {
//   double _scale = 1.0;
//   double _opacity = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           _scale = 0.95;
//           _opacity = 0.7;
//         });
//       },
//       onTapUp: (_) {
//         setState(() {
//           _scale = 1.0;
//           _opacity = 1.0;
//         });
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatPage(
//               receiverUsername: widget.username,
//               receiverId: widget.uid,
//               receiverProfile: widget.profileImg,
//             ),
//           ),
//         );
//       },
//       onTapCancel: () {
//         setState(() {
//           _scale = 1.0;
//           _opacity = 1.0;
//         });
//       },
//       child: AnimatedScale(
//         scale: _scale,
//         duration: const Duration(milliseconds: 150),
//         child: AnimatedOpacity(
//           opacity: _opacity,
//           duration: const Duration(milliseconds: 150),
//           child: Card(
//             color: Colors.white,
//             margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   ClipOval(
//                     child: Container(
//                       width: 50.0,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: widget.profileImg != "defaultIMG"
//                               ? CachedNetworkImageProvider(widget.profileImg)
//                               : const AssetImage("images/user.jpeg"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 18.0),
//                   Text(
//                     widget.username,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const Spacer(),
//                   const Icon(Icons.arrow_forward_ios,
//                       size: 16, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
