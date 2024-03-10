import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwapItButton extends StatelessWidget {
  const SwapItButton({super.key, required this.size, required this.onPressed});

  final Size size;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: Colors.transparent,
        maximumSize: Size(size.width / 2, size.width / 6),
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.white,
                child: FittedBox(
                  child: Text(
                    " SWAP ",
                    style: GoogleFonts.luckiestGuy(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                color: Colors.green,
                child: FittedBox(
                  child: Text(
                    " it ",
                    style: GoogleFonts.luckiestGuy(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
