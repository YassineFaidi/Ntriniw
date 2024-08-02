import 'dart:io';
import 'package:flutter_frontend/services/stories/story_service.dart';
import '../services/authentification/auth_service.dart';

class Story {
  final String? userImage;
  final String username;
  final String storyTime;
  final String? storyImage;

  Story({
    required this.userImage,
    required this.username,
    required this.storyTime,
    required this.storyImage,
  });

  static Future<void> createStory(AuthService authService, File imageFile) async {
    await StoryService.createStory(authService , imageFile);
  }

  static Future<List<Story>> fetchStories() async {
    return await StoryService.fetchStories();
  }
}
