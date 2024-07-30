import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/services/authentification/auth_gate.dart';
import 'package:flutter_frontend/utils/shared_prefs_helper.dart';
import 'package:flutter_frontend/views/get_statred_page.dart';
import 'package:flutter_frontend/views/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hasSeen = await SharedPrefsHelper.hasSeenGetStarted();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService()..getUser(),
    child: MyApp(hasSeen: hasSeen),
  ));
}

class MyApp extends StatefulWidget {
  final bool hasSeen;
  const MyApp({super.key, this.hasSeen = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.hasSeen
          ? const AuthGate(page: HomePage())
          : const GetStarted(),
    );
  }
}
