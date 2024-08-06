import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_post.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/utils/my_helper.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final String postId;
  const UserProfile({super.key, required this.postId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<List<dynamic>> futureUserInfo;
  List<dynamic> userInfo = [];
  int? thisUserId;

  late Future<List<Post>> futurePosts;
  List<Post>? posts;

  @override
  void initState() {
    super.initState();
    futureUserInfo = fetchUserInfo();
    futurePosts = Future.value([]); 
  }

  Future<List<dynamic>> fetchUserInfo() async {
    try {
      List<dynamic> fetchedUserInfo = await Post.getUserInfo(widget.postId);
      setState(() {
        userInfo = fetchedUserInfo;
        thisUserId = userInfo[0];
        futurePosts = fetchUserPosts();
      });
    } catch (e) {
      //
      setState(() {
        userInfo = [];
      });
    }
    return userInfo;
  }

  Future<List<Post>> fetchUserPosts() async {
    posts = await Post.fetchPostsById(thisUserId as int);
    return posts!;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userCredential;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: FutureBuilder<List<dynamic>>(
                  future: futureUserInfo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No user data found.');
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                MyHelper.getuserImg(userInfo[3] ?? ''),
                            radius: 50.0,
                          ),
                          const SizedBox(height: 20),
                          Text('UID: ${userInfo[0]}'),
                          Text('Username: ${userInfo[1]}'),
                          Text('Email: ${userInfo[2]}'),
                          const SizedBox(height: 30),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(children: [
                    SizedBox(
                      height: 260,
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(myPrimaryColor),
                      ),
                    ),
                  ]);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No posts available.'),
                  );
                } else {
                  final posts = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return MyPost(
                        actualUserId: user!.uid.toString(),
                        postId: post.postId,
                        userImage: post.userImage,
                        username: post.username,
                        postTime: post.postTime,
                        postImage: post.postImage ?? '',
                        content: post.content,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
