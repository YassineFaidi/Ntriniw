import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/chat_message.dart';
import 'package:flutter_frontend/services/chat/chat_service.dart';
import 'package:flutter_frontend/utils/my_helper.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String? userImage;
  final int userId;
  final int actualUid;

  const ChatPage(
      {super.key,
      required this.username,
      required this.userImage,
      required this.userId,
      required this.actualUid});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<ChatMessage>> futureMessages;
  List<ChatMessage>? messages;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureMessages = fetchMsgs();
  }

  Future<List<ChatMessage>> fetchMsgs() async {
    messages = await ChatService.getMsgs(widget.actualUid, widget.userId);
    return messages!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: AppBar(
              scrolledUnderElevation:0.0,
              elevation: 0,
              backgroundColor: Colors.white,
              leadingWidth: 56,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: MyHelper.getuserImg(widget.userImage)
                          as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.username,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.video_call, color: myPrimaryColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: myPrimaryColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<List<ChatMessage>>(
                  future: futureMessages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center();
                    } else {
                      final messages = snapshot.data!;
                      return ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.all(15),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final messageInfo = messages[index];
                            return ChatMessage(
                              message: messageInfo.message,
                              isSentByMe: messageInfo.isSentByMe,
                              timestamp: messageInfo.timestamp,
                            );
                          });
                    }
                  })),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -3),
            blurRadius: 6.0,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: myPrimaryColor),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: myPrimaryColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await ChatService.sendMsg(
            widget.actualUid, widget.userId, _messageController.text);
        futureMessages = fetchMsgs();
        setState(() {});
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      _messageController.clear();
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
