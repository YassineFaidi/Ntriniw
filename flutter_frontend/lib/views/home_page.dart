import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_new.dart';
import 'package:flutter_frontend/components/my_post.dart';
import 'package:flutter_frontend/components/my_story.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> futurePosts;
  List<Post>? posts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    posts = await Post.fetchPosts();
    return posts!;
  }

  Future<void> _refreshPosts() async {
    futurePosts = fetchPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: RefreshIndicator(
        color: myPrimaryColor,
        onRefresh: _refreshPosts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    NewPage(),
                    MyStory(
                        userImageUrl:
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcThF3J5WaWVDPUXiot1oCnCLM7mSAGx6PCSxMQyTs9Odd-cQHVP',
                        username: 'username'),
                    MyStory(
                        userImageUrl:
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcThF3J5WaWVDPUXiot1oCnCLM7mSAGx6PCSxMQyTs9Odd-cQHVP',
                        username: 'username'),
                    MyStory(
                        userImageUrl:
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcThF3J5WaWVDPUXiot1oCnCLM7mSAGx6PCSxMQyTs9Odd-cQHVP',
                        username: 'username'),
                    MyStory(
                        userImageUrl:
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcThF3J5WaWVDPUXiot1oCnCLM7mSAGx6PCSxMQyTs9Odd-cQHVP',
                        username: 'username'),
                    MyStory(
                        userImageUrl:
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcThF3J5WaWVDPUXiot1oCnCLM7mSAGx6PCSxMQyTs9Odd-cQHVP',
                        username: 'username'),
                    MyStory(
                        userImageUrl:
                            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcThF3J5WaWVDPUXiot1oCnCLM7mSAGx6PCSxMQyTs9Odd-cQHVP',
                        username: 'username'),
                  ],
                ),
              ),
              FutureBuilder<List<Post>>(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 240,
                        ),
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(myPrimaryColor),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 260,
                        ),
                        Text('No posts available.')
                      ],
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
