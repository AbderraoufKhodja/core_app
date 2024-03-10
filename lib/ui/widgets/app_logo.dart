import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/flavors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  final double? size;

  const AppLogo({
    this.size,
    super.key,
    this.color = Colors.grey,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    if (F.appFlavor == Flavor.swappers) {
      return PhotoWidget.asset(
        path: 'assets/swappers_512x512.webp',
        width: mediaSize.width / 2,
        height: mediaSize.width / 2,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'FiBal',
          style: GoogleFonts.fredokaOneTextTheme().displayLarge?.copyWith(
                color: color,
                fontSize: size ?? (mediaSize.width / 3.5),
              ),
        ),
        Text(
          'i',
          style: GoogleFonts.fredokaOneTextTheme().displayLarge?.copyWith(
            color: Colors.redAccent[400]!,
            fontSize: size ?? (mediaSize.width / 3.5),
            shadows: [
              Shadow(
                blurRadius: 14.0,
                color: Colors.redAccent[400]!,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
