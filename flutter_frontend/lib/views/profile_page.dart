import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:flutter_frontend/utils/my_helper.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/views/my_shared_posts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int actualUid;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userCredential;
    actualUid = user!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...[
                CircleAvatar(
                  backgroundImage: MyHelper.getuserImg(user.profileImg),
                  radius: 50.0,
                ),
                const SizedBox(height: 20),
                Text('UID: ${user.uid}'),
                Text('Username: ${user.username}'),
                Text('Email: ${user.email}'),
              ],
              const SizedBox(height: 20),
              MyButton(onTap: myShaerdPosts, text: "My posts"),
              const SizedBox(height: 10),
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

  void myShaerdPosts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MySharedPosts(
          userID: actualUid,
        ),
      ),
    );
  }

  void savedPosts() {}
}
