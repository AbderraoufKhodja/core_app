import 'package:flutter/material.dart';

class CurvedButton extends StatelessWidget {
  final Widget child;
  final double? hight;
  final EdgeInsets padding;
  final Function()? onTap;
  final Color color;

  const CurvedButton({
    Key? key,
    required this.child,
    this.hight,
    this.padding = const EdgeInsets.all(4.0),
    this.onTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        height: hight,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.4),
        ),
        child: Center(child: child),
      ),
    );
  }
}
