import 'package:flutter/material.dart';
import 'package:flutter_frontend/views/new_post.dart';
import 'package:flutter_frontend/views/new_storie.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPage extends StatefulWidget {
  const NewPage({
    super.key,
  });

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
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

  void _createNew() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text('Create New Post'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NewPost(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.recent_actors_outlined),
                title: const Text('Create New Story'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NewStory(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _createNew,
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
              children: [
                ClipOval(
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/plus.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "New",
                  style: GoogleFonts.openSans(
                    fontSize: 12.0,
                    color: Colors.black,
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
