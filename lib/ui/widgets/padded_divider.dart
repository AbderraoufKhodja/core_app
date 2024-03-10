import 'package:flutter/material.dart';

class PaddedDivider extends StatelessWidget {
  const PaddedDivider({
    Key? key,
    this.hight,
  }) : super(key: key);
  final double? hight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        height: hight,
      ),
    );
  }
}
