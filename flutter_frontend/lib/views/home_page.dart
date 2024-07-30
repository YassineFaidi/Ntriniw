import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/controllers/user_img.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
              ...[
                CircleAvatar(
                  backgroundImage: UserImg.getuserImg(user!.profileImg),
                  radius: 50.0,
                ),
                SizedBox(height: 20),
                Text('UID: ${user.uid}'),
                Text('Username: ${user.username}'),
                Text('Email: ${user.email}'),
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
