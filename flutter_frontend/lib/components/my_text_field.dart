import 'package:flutter/material.dart';
import 'package:flutter_frontend/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: myPrimaryColor,
      textAlign: TextAlign.center,
      style: GoogleFonts.openSans(
        color: Colors.black,
      ),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: myPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(90),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: myPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(90),
          ),
          fillColor: myColor2,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey)),
    );
  }
}
