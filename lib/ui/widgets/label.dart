import 'package:flutter/material.dart';

Widget labelWidget({
  required icon,
  required String text,
  required Size size,
  required String selected,
  required Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: size.height * 0.12,
          color: selected == text ? Colors.white : Colors.black54,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text(text)
      ],
    ),
  );
}
