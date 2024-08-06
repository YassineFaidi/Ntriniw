import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/post_comment_button.dart';
import 'package:flutter_frontend/components/post_content.dart';
import 'package:flutter_frontend/components/post_like_button.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:flutter_frontend/utils/my_helper.dart';
import 'package:flutter_frontend/views/my_shared_posts.dart';
import 'package:flutter_frontend/views/user_profile.dart';

class MyPost extends StatefulWidget {
  final bool isMyPost;
  final String postId;
  final String? userImage;
  final String username;
  final String postTime;
  final String postImage;
  final String content;
  final String actualUserId;

  const MyPost({
    super.key,
    required this.userImage,
    required this.username,
    required this.postTime,
    required this.postImage,
    required this.content,
    required this.postId,
    required this.actualUserId,
    this.isMyPost = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late Future<List<dynamic>> _likeData;

  @override
  void initState() {
    super.initState();
    _likeData = Post.getPostLikesCount(widget.postId, widget.actualUserId);
  }

  void goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfile(
          postId: widget.postId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _likeData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center();
        }

        int likeCount = int.parse(snapshot.data![0]);
        bool isLiked = snapshot.data![1] == 'True';
        int commentCount = int.parse(snapshot.data![2]);

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: goToProfile,
                      child: ClipOval(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MyHelper.getuserImg(widget.userImage)
                                  as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: goToProfile,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            MyHelper.getTimeAgo(widget.postTime),
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert_outlined)
                  ],
                ),
              ),
              Image(
                image: MyHelper.getDbImg(widget.postImage),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LikeButton(
                      postId: widget.postId,
                      actualUserId: widget.actualUserId,
                      initialLikeCount: likeCount,
                      initialIsLiked: isLiked,
                    ),
                    CommentSection(
                        postId: widget.postId,
                        actualUserId: widget.actualUserId,
                        initialCommentCount: commentCount),
                    const Spacer(),
                    IconButton(
                      icon: widget.isMyPost
                          ? const Icon(Icons.delete_outline_outlined)
                          : const Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                            ),
                      onPressed: () async {
                        if (widget.isMyPost) {
                          bool confirmDelete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.white,
                                    insetPadding: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Confirm Deletion',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          const Text(
                                            'Are you sure you want to delete this post?',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                ),
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ) ??
                              false;

                          if (confirmDelete) {
                            try {
                              await Post.deletePost(widget.postId);

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Post deleted successfully')),
                              );
                              Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MySharedPosts(
                                    userID: int.parse(widget.actualUserId),
                                  ),
                                ),
                              );
                            } catch (e) {
                              // Handle deletion error
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9.0, vertical: 0.0),
                child: ContentSection(content: widget.content),
              ),
            ],
          ),
        );
      },
    );
  }
}
