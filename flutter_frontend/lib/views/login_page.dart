import 'package:flutter_frontend/services/authentification/auth_service.dart';
import 'package:flutter_frontend/components/my_text_field.dart';
import 'package:flutter_frontend/components/my_button.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:flutter_frontend/constants/app_img.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwdcontroller = TextEditingController();

  Color _textColor = Colors.black;

  void signIn() async {
    if (emailcontroller.text == '' || passwdcontroller.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and password fields cannot be empty.'),
        ),
      );
    } else {
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signInWithEmailandPassword(
          emailcontroller.text,
          passwdcontroller.text,
        );
      } catch (e) {
        if (e is SocketException || e is http.ClientException) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to communicate with server!'),
            ),
          );
        } else {
          var message = e.toString();
          if (e is Exception && message.contains('Invalid credentials')) {
            message = 'Invalid credentials';
          }
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF1F6F9),
              Color(0xFFFFFDFF),
            ],
            stops: [0.1, 0.4],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(loginImg,
                        width: 100, height: 100),
                    const SizedBox(height: 25),
                    Text(
                      "Welcome back to Ntriniw",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                        controller: emailcontroller,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: passwdcontroller,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(height: 25),
                    MyButton(onTap: signIn, text: "Sign In"),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          onTapDown: (_) {
                            setState(() {
                              _textColor = myColor1;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _textColor = Colors.black;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              _textColor = Colors.black;
                            });
                          },
                          child: Text(
                            "Register now",
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
