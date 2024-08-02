import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentification/auth_gate.dart';
import 'package:flutter_frontend/views/home_page.dart';
import 'package:flutter_frontend/views/reels_page.dart';
import 'package:flutter_frontend/views/settings_page.dart';
import 'package:flutter_frontend/views/store_page.dart';
import 'package:flutter_frontend/views/workshops_page.dart';

class MyNavBar extends StatelessWidget {
  final int selectedIndex;
  const MyNavBar({super.key, required this.selectedIndex});

  void navigateTo(context, page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      if (index == 0) {
        navigateTo(context, AuthGate(page: HomePage()));
      } else if (index == 1) {
        navigateTo(context, const AuthGate(page: WorkshopsPage()));
      } else if (index == 2) {
        navigateTo(context, const AuthGate(page: ReelsPage()));
      } else if (index == 3) {
        navigateTo(context, const AuthGate(page: StorePage()));
      } else if (index == 4) {
        navigateTo(context, const AuthGate(page: SettingsPage()));
      }
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: 26,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.punch_clock,
            size: 26,
          ),
          label: 'Workshops',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.video_library_outlined,
            size: 26,
          ),
          label: 'Reels',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.store_outlined,
            size: 26,
          ),
          label: 'Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            size: 26,
          ),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 58, 163, 70),
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
    );
  }
}
