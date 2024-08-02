import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/views/home_page.dart';
import 'package:flutter_frontend/views/reels_page.dart';
import 'package:flutter_frontend/views/profile_page.dart';
import 'package:flutter_frontend/views/store_page.dart';
import 'package:flutter_frontend/views/workshops_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const WorkshopsPage(),
    const ReelsPage(),
    const StorePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.punch_clock), label: 'Workshops'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library_outlined), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: 'Store'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: myPrimaryColor,
        // unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}