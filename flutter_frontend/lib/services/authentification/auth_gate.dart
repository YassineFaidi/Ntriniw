import 'package:flutter/material.dart';
import 'package:flutter_frontend/controllers/login_or_register.dart';
import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  final StatefulWidget page;
  const AuthGate({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.userCredential != null) {
          return page;
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}
