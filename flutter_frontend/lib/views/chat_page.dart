// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:ntrriniw_v0/components/my_text_field.dart';
// import 'package:ntrriniw_v0/services/chat/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatPage extends StatefulWidget {
//   final String receiverUsername;
//   final String receiverId;
//   final String receiverProfile;

//   const ChatPage({
//     super.key,
//     required this.receiverUsername,
//     required this.receiverId,
//     required this.receiverProfile,
//   });

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   void sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(
//           widget.receiverId, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _buildChatHeader(),
//           Expanded(
//             child: _buildMessageList(),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatHeader() {
//     return SafeArea(
//       child: Container(
//         color: Colors.blueGrey[50],
//         padding: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Row(
//           children: [
//             const SizedBox(width: 12.0),
//             SizedBox(
//               width: 50.0,
//               height: 50.0,
//               child: ClipOval(
//                 child: CachedNetworkImage(
//                   imageUrl: widget.receiverProfile != "defaultIMG"
//                       ? widget.receiverProfile
//                       : 'images/user.jpeg',
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) =>
//                       const CircularProgressIndicator(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12.0),
//             Expanded(
//               child: Text(
//                 widget.receiverUsername,
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.more_vert, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     return StreamBuilder(
//       stream: _chatService.getMessages(
//         widget.receiverId,
//         _firebaseAuth.currentUser!.uid,
//       ),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return ListView(
//           padding: const EdgeInsets.all(8.0),
//           children: snapshot.data!.docs
//               .map((document) => _buildMessageItem(document))
//               .toList(),
//         );
//       },
//     );
//   }

//   Widget _buildMessageItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//     bool isCurrentUser = data["senderId"] == _firebaseAuth.currentUser!.uid;
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5.0),
//       alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//         decoration: BoxDecoration(
//           color: isCurrentUser ? const Color.fromARGB(255, 58, 163, 70) : Colors.grey[300],
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Text(
//           data["message"],
//           style: TextStyle(
//             color: isCurrentUser ? Colors.white : Colors.black87,
//             fontSize: 16.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: MyTextField(
//               controller: _messageController,
//               hintText: "Enter a message...",
//               obscureText: false,
//             ),
//           ),
//           IconButton(
//             onPressed: sendMessage,
//             icon: const Icon(
//               Icons.send,
//               color: Color.fromARGB(255, 58, 163, 70),
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
