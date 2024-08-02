import 'dart:io';
import 'package:flutter_frontend/services/posts/post_service.dart';
import '../services/authentification/auth_service.dart';

class Post {
  final String? userImage;
  final String username;
  final String postTime;
  final String content;
  final String? postImage;

  Post({
    required this.userImage,
    required this.username,
    required this.postTime,
    required this.content,
    required this.postImage,
  });

  static Future<void> createPost(AuthService authService, String content, File imageFile) async {
    await PostService.createPost(authService, content, imageFile);
  }

  static Future<List<Post>> fetchPosts() async {
    return await PostService.fetchPosts();
  }
}
