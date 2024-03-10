import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';

class HomeBadge extends StatefulWidget {
  final bool isActive;

  const HomeBadge({Key? key, required this.isActive}) : super(key: key);

  @override
  State<HomeBadge> createState() => _HomeBadgeState();
}

class _HomeBadgeState extends State<HomeBadge> {
  @override
  Widget build(BuildContext context) {
    return Iconify(
      Carbon.globe,
      color: Get.isDarkMode ? Colors.white : Colors.grey,
      size: 28,
    );
  }
}
