import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // Check if userCredential is available
    final user = authService.userCredential;

    ImageProvider? profileImage;

    profileImage = MemoryImage(base64Decode(user!.profileImg));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display user info
              if (user != null) ...[
                CircleAvatar(
                  backgroundImage: profileImage,
                  radius: 50.0,
                ),
                SizedBox(height: 20),
                Text('UID: ${user.uid}'),
                Text('Username: ${user.username}'),
                Text('Email: ${user.email}'),
              ] else ...[
                Text('No user is logged in'),
              ],
              SizedBox(height: 20),
              MyButton(onTap: signOut, text: "Sign Out"),
            ],
          ),
        ),
      ),
    );
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
}
