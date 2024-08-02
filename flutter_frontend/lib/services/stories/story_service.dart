import 'package:flutter_frontend/models/story.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class StoryService {
  static Future<void> createStory(
      AuthService authService, File imageFile) async {
    final user = authService.userCredential;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    String base64Image = base64Encode(await imageFile.readAsBytes());

    final response = await http.post(
      Uri.parse(newStoryEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': user.uid.toString(),
        'storyImg': base64Image,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create story');
    }

    final responseBody = jsonDecode(response.body);
    if (!responseBody['success']) {
      throw Exception('Story creation failed');
    }
  }

  static Future<List<Story>> fetchStories() async {
    try {
      final response = await http.get(Uri.parse(getStoriesEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true &&
            responseBody.containsKey('stories')) {
          final List<dynamic> postsData = responseBody['stories'];
          return postsData.map((data) {
            return Story(
              username: data['username'],
              storyImage: data['image'],
              userImage: data['userImage'] ?? '',
              storyTime: data['created_at'],
            );
          }).toList();
        } else {
          throw Exception('Failed to load stories');
        }
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (e) {
      return [];
    }
  }
}
