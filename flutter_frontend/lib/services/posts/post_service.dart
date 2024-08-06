import 'package:flutter_frontend/models/comment.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/constants/api_endpoints.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class PostService {
  static Future<void> createPost(
      AuthService authService, String content, File imageFile) async {
    final user = authService.userCredential;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    String base64Image = base64Encode(await imageFile.readAsBytes());

    final response = await http.post(
      Uri.parse(newPostEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': user.uid.toString(),
        'content': content,
        'postImg': base64Image,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create post');
    }

    final responseBody = jsonDecode(response.body);
    if (!responseBody['success']) {
      throw Exception('Post creation failed');
    }
  }

  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(getPostsEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true &&
            responseBody.containsKey('posts')) {
          final List<dynamic> postsData = responseBody['posts'];
          return postsData.map((data) {
            return Post(
              username: data['username'],
              content: data['content'],
              postImage: data['image'],
              userImage: data['userImage'] ?? '',
              postTime: data['created_at'],
              postId: data['postId'],
            );
          }).toList();
        } else {
          throw Exception('Failed to load posts');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List> getPostLikesCount(
      String postId, String actualUserId) async {
    try {
      final response = await http.post(
        Uri.parse(getLCCountEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'postId': postId,
          'actualUserId': actualUserId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true &&
            responseBody.containsKey('likes_count')) {
          final String likesCount = responseBody['likes_count'];
          final String isLiked = responseBody['isLiked'];
          final String commentsCount = responseBody['comments_count'];

          return [likesCount, isLiked, commentsCount];
        } else {
          throw Exception('Failed to load post likes');
        }
      } else {
        throw Exception('Failed to load post likes');
      }
    } catch (e) {
      return [];
    }
  }

  static Future<void> setPostLike(
      String postId, String userId, bool isLiked) async {
    final response = await http.post(
      Uri.parse(setPostLikeEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'postId': postId,
        'userId': userId,
        'isLiked': isLiked.toString(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }

    final responseBody = jsonDecode(response.body);
    if (!responseBody['success']) {
      throw Exception('Liking post failed');
    }
  }

  static Future<void> addComment(
      String postId, String userId, String comment) async {
    final response = await http.post(
      Uri.parse(addPostCommentEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'postId': postId,
        'userId': userId,
        'comment': comment,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }

    final responseBody = jsonDecode(response.body);
    if (!responseBody['success']) {
      throw Exception('Adding post comment failed');
    }
  }

  static Future<List<Comment>> getPostComments(String postId) async {
    try {
      final response = await http.post(
        Uri.parse(getPostCommentsEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'postId': postId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true &&
            responseBody.containsKey('comments')) {
          final List<dynamic> commentsList = responseBody['comments'];
          return commentsList.map((data) {
            return Comment(
                username: data['username'],
                userImage: data['userImage'] ?? '',
                comment: data['comment']);
          }).toList();
        } else {
          throw Exception('Failed to load post comments');
        }
      } else {
        throw Exception('Failed to load post comments');
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Post>> fetchPostsById(int userID) async {
    try {
      final response = await http.post(
        Uri.parse(getPostsByIdEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userID': userID.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true &&
            responseBody.containsKey('posts')) {
          final List<dynamic> postsData = responseBody['posts'];
          return postsData.map((data) {
            return Post(
              username: data['username'],
              content: data['content'],
              postImage: data['image'],
              userImage: data['userImage'] ?? '',
              postTime: data['created_at'],
              postId: data['postId'],
            );
          }).toList();
        } else {
          throw Exception('Failed to load posts');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      return [];
    }
  }

  static Future<void> deletePost(String postId) async {
    final response = await http.post(
      Uri.parse(deletePostEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'postId': postId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }

    final responseBody = jsonDecode(response.body);
    if (!responseBody['success']) {
      throw Exception('Failed to delete post');
    }
  }

  static Future<List<dynamic>> getUserInfo(String postId) async {
    try {
      final response = await http.post(
        Uri.parse(getUserInfoEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'postId': postId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true &&
            responseBody.containsKey('user')) {
          final List<dynamic> userInfo = responseBody['user'];
          return userInfo;
        } else {
          throw Exception('Failed to load user info');
        }
      } else {
        throw Exception('Failed to load user info');
      }
    } catch (e) {
      return [];
    }
  }
}
