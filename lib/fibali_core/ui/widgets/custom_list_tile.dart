import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.leading,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final Widget leading;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      visualDensity: VisualDensity(horizontal: 0, vertical: -2),
      leading: leading,
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: onTap == null ? Colors.grey : null)),
      onTap: onTap,
      horizontalTitleGap: 5,
    );
  }
}
