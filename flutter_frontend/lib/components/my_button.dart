import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_frontend/constants/app_colors.dart';

class MyButton extends StatefulWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  double opacityLevel = 1.0;
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          opacityLevel = 0.7;
          scale = 0.9;
        });
      },
      onTapUp: (details) {
        setState(() {
          opacityLevel = 1.0;
          scale = 1.0;
        });
      },
      onTapCancel: () {
        setState(() {
          opacityLevel = 1.0;
          scale = 1.0;
        });
      },
      onTap: widget.onTap,
      child: Opacity(
        opacity: opacityLevel,
        child: Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: myPrimaryColor,
              borderRadius: BorderRadius.circular(90),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
