import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/utils/my_helper.dart';
import 'package:flutter_frontend/views/chat_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LatestChatItem extends StatelessWidget {
  final String username;
  final String userImg;
  final String lastMessage;
  final String timestamp;
  final int userId;

  const LatestChatItem({
    super.key,
    required this.username,
    required this.userImg,
    required this.lastMessage,
    required this.timestamp,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final actualUser = authService.userCredential;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: MyHelper.getuserImg(userImg),
      ),
      title: Text(username),
      subtitle: Text(lastMessage),
      trailing: Text(DateFormat('hh:mm a').format(DateTime.parse(timestamp))),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              username: username,
              userImage: userImg,
              userId: userId,
              actualUid: actualUser!.uid,
            ),
          ),
        );
      },
    );
  }
}
