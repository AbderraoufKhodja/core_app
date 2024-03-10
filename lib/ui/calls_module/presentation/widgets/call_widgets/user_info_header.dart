import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class UserInfoHeader extends StatelessWidget {
  final String? avatar;
  final String? name;

  const UserInfoHeader({
    Key? key,
    required this.avatar,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.grey.withOpacity(0.2),
          child: avatar?.isNotEmpty == true
              ? PhotoWidgetNetwork(
                  label: Utils.getInitial(name),
                  photoUrl: avatar ?? '',
                  width: 25.0,
                  height: 25.0,
                  boxShape: BoxShape.circle,
                )
              : const Icon(Icons.person),
        ),
        const SizedBox(
          width: 10.0,
        ),
        if (name != null)
          Text(
            name!,
            style: const TextStyle(color: Colors.white),
          ),
      ],
    );
  }
}
