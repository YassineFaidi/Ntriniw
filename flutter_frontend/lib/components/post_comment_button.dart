import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/models/comment.dart';
import 'package:flutter_frontend/models/post.dart';
import 'package:flutter_frontend/utils/my_helper.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  final String actualUserId;
  final int initialCommentCount;

  const CommentSection({
    super.key,
    required this.postId,
    required this.actualUserId,
    required this.initialCommentCount,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late int _commentCount;
  final TextEditingController _commentController = TextEditingController();

  late Future<List<Comment>> futureComments;
  List<Comment>? comments;

  List<dynamic> getPostComments = [];

  @override
  void initState() {
    super.initState();
    _commentCount = widget.initialCommentCount;
    futureComments = loadComments();
  }

  Future<List<Comment>> loadComments() async {
    comments = await Post.getPostComments(widget.postId);
    return comments!;
  }

  void addComment() async {
    if (_commentController.text.isNotEmpty) {
      await Post.addComment(
          widget.postId, widget.actualUserId, _commentController.text);
      setState(() {
        _commentCount += 1;
      });
      _commentController.clear();
      futureComments = loadComments();
    }
  }

  void _showCommentsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40.0),
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: FutureBuilder<List<Comment>>(
                        future: futureComments,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center();
                          } else {
                            final comments = snapshot.data!;
                            return ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final commentInfo = comments[index];
                                  return _buildCommentTile(
                                      commentInfo.username,
                                      commentInfo.comment,
                                      commentInfo.userImage);
                                });
                          }
                        })),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: myPrimaryColor, width: 0.8),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: myPrimaryColor, width: 1.4),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: myPrimaryColor,
                        ),
                        onPressed: addComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentTile(String username, String comment, String? userImage) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      leading: ClipOval(
          child: Image(
              image: MyHelper.getuserImg(userImage) as ImageProvider<Object>,
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover)),
      title:
          Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(comment),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: _showCommentsPopup,
        ),
        Text(
          '$_commentCount',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
