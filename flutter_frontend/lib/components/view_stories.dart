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
          return SafeArea(
            child: Container(
              color: Colors.black,
              child: Column(
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
                                image: MyHelper.getuserImg(story.userImage)
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
                              story.username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              MyHelper.getTimeAgo(story.storyTime),
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.white),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.more_vert_outlined, color: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image(
                        image: MyHelper.getDbImg(story.storyImage!),
                      ),
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
