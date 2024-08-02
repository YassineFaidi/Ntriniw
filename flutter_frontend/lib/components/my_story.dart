import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStory extends StatefulWidget {
  final String userImageUrl;
  final String username;

  const MyStory(
      {super.key, required this.userImageUrl, required this.username});

  @override
  State<MyStory> createState() => _MyStoryState();
}

class _MyStoryState extends State<MyStory> {
  double _opacity = 1.0;
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _opacity = 0.6;
      _scale = 0.9;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Opacity(
        opacity: _opacity,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74.0,
                  height: 74.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 58, 163, 70),
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl: widget.userImageUrl,
                    fit: BoxFit.cover,
                  )),
                ),
                const SizedBox(height: 4.0),
                Flexible(
                  child: Text(
                    widget.username,
                    style: GoogleFonts.openSans(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
