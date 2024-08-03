import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/story.dart';
import 'package:flutter_frontend/utils/my_helper.dart';

class ViewStories extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const ViewStories(
      {super.key, required this.stories, required this.initialIndex});

  @override
  _ViewStoriesState createState() => _ViewStoriesState();
}

class _ViewStoriesState extends State<ViewStories> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.stories.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final story = widget.stories[index];
          return Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: MyHelper.getDbImg(story.storyImage!),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    story.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    story.storyTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
