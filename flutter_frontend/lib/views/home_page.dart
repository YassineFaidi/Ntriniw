import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_new.dart';
import 'package:flutter_frontend/components/my_post.dart';
import 'package:flutter_frontend/components/my_story.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:flutter_frontend/models/story.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> futurePosts;
  List<Post>? posts;

  late Future<List<Story>> futureStories;
  List<Story>? stories;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
    futureStories = fetchStories();
  }

  Future<List<Post>> fetchPosts() async {
    posts = await Post.fetchPosts();
    return posts!;
  }

  Future<List<Story>> fetchStories() async {
    stories = await Story.fetchStories();
    return stories!;
  }

  Future<void> _refresh() async {
    futurePosts = fetchPosts();
    futureStories = fetchStories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 110,
                child: FutureBuilder<List<Story>>(
                  future: futureStories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No stories available.'),
                      );
                    } else {
                      final stories = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: stories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const NewPage();
                          } else {
                            final story = stories[index - 1];
                            return MyStory(
                              userImage: story.userImage,
                              username: story.username,
                              storyImage: story.storyImage,
                              storyTime: story.storyTime,
                              stories: stories,
                              index: index - 1,
                            );
                          }
                        },
                      );
                    }
                  },
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
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(myPrimaryColor),
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
