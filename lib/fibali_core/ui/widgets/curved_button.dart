import 'package:flutter/material.dart';

class CurvedButton extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsets padding;
  final Function()? onTap;
  final Color color;

  const CurvedButton({
    Key? key,
    required this.child,
    this.height,
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
        height: height,
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
