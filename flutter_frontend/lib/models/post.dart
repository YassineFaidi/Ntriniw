import 'dart:io';
import 'package:flutter_frontend/models/comment.dart';
import 'package:flutter_frontend/services/posts/post_service.dart';
import '../services/authentification/auth_service.dart';

class Post {
  final String postId;
  final String? userImage;
  final String username;
  final String postTime;
  final String content;
  final String? postImage;

  Post({
    required this.postId,
    required this.userImage,
    required this.username,
    required this.postTime,
    required this.content,
    required this.postImage,
  });

  static Future<void> createPost(
      AuthService authService, String content, File imageFile) async {
    await PostService.createPost(authService, content, imageFile);
  }

  static Future<List<Post>> fetchPosts() async {
    return await PostService.fetchPosts();
  }

  static Future<List> getPostLikesCount(
      String postId, String actualUserId) async {
    return await PostService.getPostLikesCount(postId, actualUserId);
  }

  static Future<void> setPostLike(
      String postId, String userId, bool isLiked) async {
    await PostService.setPostLike(postId, userId, isLiked);
  }

  static Future<void> addComment(
      String postId, String userId, String comment) async {
    await PostService.addComment(postId, userId, comment);
  }

  static Future<List<Comment>> getPostComments(String postId) async {
    return await PostService.getPostComments(postId);
  }

  static Future<List<Post>> fetchPostsById(int userID) async {
    return await PostService.fetchPostsById(userID);
  }

  static Future<void> deletePost(String postId) async {
    return await PostService.deletePost(postId);
  }

  static Future<List<dynamic>>getUserInfo(String postId) async {
    return await PostService.getUserInfo(postId);
  }
}
