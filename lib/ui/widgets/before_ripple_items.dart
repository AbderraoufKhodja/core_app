import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BeforeProgressRipple extends StatelessWidget {
  const BeforeProgressRipple({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final icons = <FaIcon>[
      FaIcon(FontAwesomeIcons.headphones, size: size.width / 6),
      FaIcon(Icons.watch, size: size.width / 6),
      FaIcon(FontAwesomeIcons.laptop, size: size.width / 6),
      FaIcon(FontAwesomeIcons.mobileScreenButton, size: size.width / 5.5),
      FaIcon(FontAwesomeIcons.bicycle, size: size.width / 6),
      FaIcon(FontAwesomeIcons.shirt, size: size.width / 6.5),
      FaIcon(FontAwesomeIcons.glasses, size: size.width / 6),
      FaIcon(FontAwesomeIcons.bookOpen, size: size.width / 6),
      FaIcon(FontAwesomeIcons.chair, size: size.width / 5.5),
    ];
    return Center(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(right: size.width / 20),
          child: SpinKitFadingGrid(
            size: size.width * 0.6,
            shape: BoxShape.circle,
            itemBuilder: (context, index) => icons[index],
          ),
        ),
      ),
    );
  }
}
