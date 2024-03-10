import 'package:flutter/material.dart';

class PopButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? color;

  const PopButton({
    Key? key,
    this.onPressed,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: color,
      ),
      onPressed: onPressed ?? () => Navigator.pop(context),
    );
  }
}
