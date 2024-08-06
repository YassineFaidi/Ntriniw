import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/latest_chat_item.dart';
import 'package:flutter_frontend/models/user_credential.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/services/chat/chat_service.dart';
import 'package:flutter_frontend/utils/my_helper.dart';
import 'package:flutter_frontend/views/chat_page.dart';
import 'package:provider/provider.dart';

class LatestChatPage extends StatefulWidget {
  const LatestChatPage({super.key});

  @override
  State<LatestChatPage> createState() => _LatestChatPageState();
}

class _LatestChatPageState extends State<LatestChatPage> {
  late Future<List<UserCredential>> futureUsers;
  List<UserCredential>? users;
  late int actualUid;

  late Future<List<LatestChatItem>> futureLatests;
  List<LatestChatItem>? latests;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    final actualUser = authService.userCredential;
    actualUid = actualUser!.uid;
    futureLatests = fetchLatests();
  }

  Future<List<LatestChatItem>> fetchLatests() async {
    latests = await ChatService.getLatest(actualUid);
    return latests!;
  }

  Future<List<UserCredential>> fetchUsers() async {
    users = await ChatService.fetchUsers();
    return users!;
  }

  void _showNewChatPopup() {
    futureUsers = fetchUsers();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40.0),
                      const Text(
                        'New chat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: FutureBuilder<List<UserCredential>>(
                        future: futureUsers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center();
                          } else {
                            final users = snapshot.data!;
                            return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final userInfo = users[index];
                                  if (userInfo.uid != actualUid) {
                                    return _buildUserTile(userInfo.uid,
                                        userInfo.username, userInfo.profileImg);
                                  } else {
                                    return null;
                                  }
                                });
                          }
                        })),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserTile(int userId, String username, String? userImage) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      leading: ClipOval(
          child: Image(
              image: MyHelper.getuserImg(userImage) as ImageProvider<Object>,
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover)),
      title:
          Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.more_vert_outlined),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              username: username,
              userImage: userImage,
              userId: userId,
              actualUid: actualUid,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chats'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<LatestChatItem>>(
            future: futureLatests,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center();
              } else {
                final latests = snapshot.data!;
                return ListView.builder(
                  itemCount: latests.length,
                  itemBuilder: (context, index) {
                    final latestInfo = latests[index];
                    return LatestChatItem(
                        username: latestInfo.username,
                        userImg: latestInfo.userImg,
                        lastMessage: latestInfo.lastMessage,
                        timestamp: latestInfo.timestamp,
                        userId: latestInfo.userId,
                        );
                  },
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myPrimaryColor,
        onPressed: _showNewChatPopup,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
