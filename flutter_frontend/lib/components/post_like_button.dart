import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/post.dart';

class LikeButton extends StatefulWidget {
  final String postId;
  final String actualUserId;
  final int initialLikeCount;
  final bool initialIsLiked;

  const LikeButton({
    super.key,
    required this.postId,
    required this.actualUserId,
    required this.initialLikeCount,
    required this.initialIsLiked,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late int _likeCount;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.initialLikeCount;
    _isLiked = widget.initialIsLiked;
  }

  void _toggleLike() async {
    if (_isLiked) {
      await Post.setPostLike(widget.postId, widget.actualUserId, true);
      setState(() {
        _isLiked = false;
        _likeCount -= 1;
      });
    } else {
      await Post.setPostLike(widget.postId, widget.actualUserId, false);
      setState(() {
        _isLiked = true;
        _likeCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: _isLiked
              ? const Icon(Icons.thumb_up_alt)
              : const Icon(Icons.thumb_up_alt_outlined),
          onPressed: _toggleLike,
        ),
        Text(
          '$_likeCount',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
