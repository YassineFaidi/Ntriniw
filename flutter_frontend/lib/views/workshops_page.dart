import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_nav_bar.dart';

class WorkshopsPage extends StatefulWidget {
  const WorkshopsPage({super.key});

  @override
  State<WorkshopsPage> createState() => _HomePageState();
}

class _HomePageState extends State<WorkshopsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Text(
            "The worksops page ",
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: MyNavBar(selectedIndex: 1));
  }
}
