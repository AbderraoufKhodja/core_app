import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class LabeledIcon extends StatelessWidget {
  const LabeledIcon({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Iconify(
                icon,
                color: Colors.grey,
              )),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
