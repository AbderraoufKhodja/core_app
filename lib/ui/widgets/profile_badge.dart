import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';

class ProfileBadge extends StatefulWidget {
  final bool isActive;

  const ProfileBadge({Key? key, required this.isActive}) : super(key: key);

  @override
  State<ProfileBadge> createState() => _ProfileBadgeState();
}

class _ProfileBadgeState extends State<ProfileBadge> {
  @override
  Widget build(BuildContext context) {
    return Iconify(
      Carbon.user,
      color: Get.isDarkMode ? Colors.white : Colors.grey,
      size: 28,
    );
  }
}
