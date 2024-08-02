import 'package:flutter/material.dart';
import 'package:flutter_frontend/components/my_app_bar.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:flutter_frontend/components/my_nav_bar.dart';
import 'package:flutter_frontend/utils/images_helper.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.userCredential;

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
                  backgroundImage: UserImg.getuserImg(user!.profileImg),
                  radius: 50.0,
                ),
                const SizedBox(height: 20),
                Text('UID: ${user.uid}'),
                Text('Username: ${user.username}'),
                Text('Email: ${user.email}'),
              ],
              const SizedBox(height: 20),
              MyButton(onTap: signOut, text: "Sign Out"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyNavBar(selectedIndex: 4),
    );
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
}
