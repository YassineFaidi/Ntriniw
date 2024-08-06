import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_post.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:provider/provider.dart';

class MySharedPosts extends StatefulWidget {
  final int userID;
  const MySharedPosts({super.key, required this.userID});

  @override
  State<MySharedPosts> createState() => _MySharedPostsState();
}

class _MySharedPostsState extends State<MySharedPosts> {
  late Future<List<Post>> futurePosts;
  List<Post>? posts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchMyPosts();
  }

  Future<List<Post>> fetchMyPosts() async {
    posts = await Post.fetchPostsById(widget.userID);
    return posts!;
  }

  Future<void> _refresh() async {
    futurePosts = fetchMyPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userCredential;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: RefreshIndicator(
        color: myPrimaryColor,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
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
                          isMyPost: true,
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
      ),
    );
  }
}
