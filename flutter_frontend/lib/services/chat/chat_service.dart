import 'package:flutter_frontend/constants/api_endpoints.dart';
import 'package:flutter_frontend/models/chat_message.dart';
import 'package:flutter_frontend/models/latest_chat_item.dart';
import 'package:flutter_frontend/models/user_credential.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatService {
  static Future<List<UserCredential>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(getUsersEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true &&
            responseBody.containsKey('users')) {
          final List<dynamic> usersData = responseBody['users'];
          return usersData.map((data) {
            return UserCredential(
              uid: int.parse(data['uid']),
              username: data['username'],
              email: data['email'],
              profileImg: data['profileImg'] ?? '',
            );
          }).toList();
        } else {
          throw Exception('Failed to load users');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      return [];
    }
  }

  static Future<void> sendMsg(
      int senderId, int receiverId, String content) async {
    final response = await http.post(
      Uri.parse(sendMsgEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'senderId': senderId.toString(),
        'receiverId': receiverId.toString(),
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }

    final responseBody = jsonDecode(response.body);
    if (!responseBody['success']) {
      throw Exception('Failed to send message');
    }
  }

  static Future<List<ChatMessage>> getMsgs(int senderId, int receiverId) async {
    try {
      final response = await http.post(
        Uri.parse(getMsgsEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'senderId': senderId.toString(),
          'receiverId': receiverId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true &&
            responseBody.containsKey('messages')) {
          final List<dynamic> messagesList = responseBody['messages'];
          return messagesList.map((data) {
            bool isSentByMe;
            if (senderId == int.parse(data['sender_id'])) {
              isSentByMe = true;
            } else {
              isSentByMe = false;
            }
            return ChatMessage(
              message: data['content'],
              isSentByMe: isSentByMe,
              timestamp: data['created_at'],
            );
          }).toList();
        } else {
          throw Exception('Failed to load messages');
        }
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<LatestChatItem>> getLatest(int senderId) async {
    try {
      final response = await http.post(
        Uri.parse(getLatestEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'senderId': senderId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true &&
            responseBody.containsKey('latests')) {
          final List<dynamic> latestsList = responseBody['latests'];
          return latestsList.map((data) {
            return LatestChatItem(
              username: data['receiver_username'],
              userImg: data['receiver_img'] ?? '',
              lastMessage: data['last_msg'],
              timestamp: data['created_at'],
              userId: int.parse(data['receiver_id']),
            );
          }).toList();
        } else {
          throw Exception('Failed to load latests');
        }
      } else {
        throw Exception('Failed to load latests');
      }
    } catch (e) {
      return [];
    }
  }
}
