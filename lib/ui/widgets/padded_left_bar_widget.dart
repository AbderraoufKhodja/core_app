import 'package:flutter/material.dart';

class PaddedLeftBar extends StatelessWidget {
  const PaddedLeftBar({
    super.key,
    this.child,
    this.color = Colors.grey,
    this.width = 3.0,
    this.space = 8.0,
    this.padding = const EdgeInsets.only(left: 32.0),
  });

  final Widget? child;
  final Color color;
  final double width;
  final double space;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: color,
                width: width,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: space),
            child: child,
          ),
        ));
  }
}
