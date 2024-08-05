import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/post_comment_button.dart';
import 'package:flutter_frontend/components/post_content.dart';
import 'package:flutter_frontend/components/post_like_button.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:flutter_frontend/utils/my_helper.dart';

class MyPost extends StatefulWidget {
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
  });

  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  late Future<List<dynamic>> _likeData;

  @override
  void initState() {
    super.initState();
    _likeData = Post.getPostLikesCount(widget.postId, widget.actualUserId);
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
                    ClipOval(
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
                    const SizedBox(width: 8.0),
                    Column(
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
                      icon: const Icon(Icons.save_outlined),
                      onPressed: () {},
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
