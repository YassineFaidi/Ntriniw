// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// class ViewStory extends StatefulWidget {
//   final List<Map<String, dynamic>> stories;
//   final Duration displayDuration;

//   const ViewStory({
//     super.key,
//     required this.stories,
//     this.displayDuration = const Duration(seconds: 5),
//   });

//   @override
//   _ViewStoryState createState() => _ViewStoryState();
// }

// class _ViewStoryState extends State<ViewStory> {
//   late Timer _timer;
//   bool _isPaused = false;
//   bool _isRowVisible = true;
//   late Duration _remainingTime;
//   int _currentStoryIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _remainingTime = widget.displayDuration;
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingTime.inSeconds <= 0) {
//         _nextStory();
//       } else if (!_isPaused) {
//         setState(() {
//           _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
//         });
//       }
//     });
//   }

//   void _nextStory() {
//     if (_currentStoryIndex < widget.stories.length - 1) {
//       setState(() {
//         _currentStoryIndex++;
//         _remainingTime = widget.displayDuration;
//       });
//     } else {
//       _closeStory();
//     }
//   }

//   void _previousStory() {
//     if (_currentStoryIndex > 0) {
//       setState(() {
//         _currentStoryIndex--;
//         _remainingTime = widget.displayDuration;
//       });
//     }
//   }

//   void _pauseTimer(_) {
//     setState(() {
//       _isPaused = true;
//       _isRowVisible = false;
//     });
//   }

//   void _resumeTimer(_) {
//     setState(() {
//       _isPaused = false;
//       _isRowVisible = true;
//     });
//   }

//   void _resumeTimer2() {
//     setState(() {
//       _isPaused = false;
//       _isRowVisible = true;
//     });
//   }

//   void _closeStory() {
//     _timer.cancel();
//     Navigator.of(context).pop();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var currentStory = widget.stories[_currentStoryIndex];
//     String colorValueString = currentStory['backgroundColor']
//         .replaceAll("Color(", "")
//         .replaceAll(")", "");
//     int colorValue = int.parse(colorValueString);
//     Color backColor = Color(colorValue);

//     return Scaffold(
//       backgroundColor: backColor,
//       body: SafeArea(
//         child: GestureDetector(
//           onHorizontalDragEnd: (details) {
//             if (details.primaryVelocity! > 0) {
//               _previousStory(); // Swipe right to go to the previous story
//             } else if (details.primaryVelocity! < 0) {
//               _nextStory(); // Swipe left to go to the next story
//             }
//           },
//           onTapDown: _pauseTimer,
//           onTapUp: _resumeTimer,
//           onTapCancel: _resumeTimer2,
//           child: Stack(
//             children: [
//               Center(
//                 child: CachedNetworkImage(
//                   imageUrl: currentStory['storyImageUrl'],
//                   fit: BoxFit.contain,
//                   width: double.infinity,
//                 ),
//               ),
//               if (_isRowVisible)
//                 Positioned(
//                   top: 6.0,
//                   left: 6.0,
//                   right: 0.0,
//                   child: Row(
//                     children: [
//                       ClipOval(
//                         child: Container(
//                           width: 40.0,
//                           height: 40.0,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                               image:
//                                   currentStory['userImageUrl'] != "defaultIMG"
//                                       ? CachedNetworkImageProvider(
//                                           currentStory['userImageUrl'])
//                                       : const AssetImage("images/user.jpeg")
//                                           as ImageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8.0),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             currentStory['username'],
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           Text(
//                             _getTimeAgo(currentStory['storyTime']),
//                             style: const TextStyle(
//                                 fontSize: 12.0, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getTimeAgo(Timestamp timestamp) {
//     final DateTime postTime = timestamp.toDate();
//     final Duration difference = DateTime.now().difference(postTime);

//     if (difference.inDays > 0) {
//       return '${difference.inDays} days ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hours ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minutes ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }
