import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 26),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.chat_outlined, size: 26),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         const LatestChatPage(),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) {
            //       return FadeTransition(
            //         opacity: animation,
            //         child: child,
            //       );
            //     },
            //   ),
            // );
          },
        )
      ],
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.white,
      title: Text(
        "Ntriniw",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class LatestChatPage {
  const LatestChatPage();
}
