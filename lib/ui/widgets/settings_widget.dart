import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  final double size;
  final Color barColor;
  final Color nodeColor;

  const SettingsWidget({
    super.key,
    this.size = 20,
    required this.barColor,
    required this.nodeColor,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          bd.Badge(
            badgeStyle: bd.BadgeStyle(
              shape: bd.BadgeShape.instagram,
              padding: EdgeInsets.all(size / 5),
              badgeColor: nodeColor,
            ),
            position: bd.BadgePosition.custom(start: size / 6.5),
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(size),
              ),
              height: size / 6,
              width: size * 1.5,
            ),
          ),
          bd.Badge(
            position: bd.BadgePosition.custom(end: 0),
            badgeStyle: bd.BadgeStyle(
              shape: bd.BadgeShape.instagram,
              padding: EdgeInsets.all(size / 5),
              badgeColor: nodeColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(size),
              ),
              height: size / 6,
              width: size * 1.5,
            ),
          ),
          bd.Badge(
            position: bd.BadgePosition.custom(start: size / 2.5),
            badgeStyle: bd.BadgeStyle(
              shape: bd.BadgeShape.instagram,
              padding: EdgeInsets.all(size / 5),
              badgeColor: nodeColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(size),
              ),
              height: size / 6,
              width: size * 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
