import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Soo9Logo extends StatelessWidget {
  final double size;
  final double opacity;
  final double angle;
  final double elevation;

  const Soo9Logo({
    Key? key,
    this.size = 20,
    this.opacity = 1,
    this.angle = 50,
    this.elevation = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'SOO',
          style: GoogleFonts.alice().copyWith(fontSize: size),
        ),
        Text(
          '9',
          style: GoogleFonts.alice().copyWith(
            fontSize: size * 1.7,
            color: Colors.red.shade400,
          ),
        ),
      ],
    );
  }
}
