import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;

class SettingsWidget extends StatelessWidget {
  final double size;
  final Color barColor;
  final Color nodeColor;

  const SettingsWidget({
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
          Badge(
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(size),
              ),
              height: size / 6,
              width: size * 1.5,
            ),
          ),
          Badge(
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(size),
              ),
              height: size / 6,
              width: size * 1.5,
            ),
          ),
          Badge(
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
