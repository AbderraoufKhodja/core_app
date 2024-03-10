import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SwapItemLikes extends StatelessWidget {
  const SwapItemLikes({
    super.key,
    required this.like,
    required this.heroTag,
    this.starsColor = Colors.white70,
    this.voidStarsColor = const Color(0xFFFFDAAE),
    this.iconSize = 18,
    this.fontSize = 14,
  });

  final int like;
  final Color starsColor;
  final Color voidStarsColor;
  final double iconSize;
  final double fontSize;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'star$heroTag',
          child: FaIcon(
            FontAwesome.heart,
            color: starsColor,
            size: iconSize,
          ),
        ),
        Hero(
          tag: 'rate$heroTag',
          child: Material(
            color: Colors.transparent,
            child: Text(
              ' $like',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: starsColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
