import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_nav_bar.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ReelsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Text(
            "The reels page ",
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: MyNavBar(selectedIndex: 2));
  }
}
