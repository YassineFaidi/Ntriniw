import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
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
        );
  }
}
