import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/my_helper.dart';

class MyPost extends StatefulWidget {
  final String? userImage;
  final String username;
  final String postTime;
  final String postImage;
  final String content;

  const MyPost({
    super.key,
    required this.userImage,
    required this.username,
    required this.postTime,
    required this.postImage,
    required this.content,
  });

  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  bool _isExpanded = false;
  bool _isLiked = false;
  int _likeCount = 117;
  int _commentCount = 117;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: _isLiked
                      ? const Icon(Icons.thumb_up_alt)
                      : const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () {},
                ),
                Text(
                  '$_likeCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: _toggleExpanded,
                ),
                Text(
                  '$_commentCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isExpanded
                    ? GestureDetector(
                        onTap: _toggleExpanded,
                        child: Text(
                          widget.content,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      )
                    : GestureDetector(
                        onTap: _toggleExpanded,
                        child: Text(
                          widget.content,
                          style: const TextStyle(fontSize: 14.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                const SizedBox(height: 10),
                _isExpanded
                    ? Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return null;
                            },
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Add a comment...',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Color.fromARGB(255, 58, 163, 70),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
