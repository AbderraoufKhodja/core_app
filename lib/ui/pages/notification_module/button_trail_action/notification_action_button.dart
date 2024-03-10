import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/ui/pages/notification_module/button_trail_action/friend_request_action_button.dart';
import 'package:fibali/ui/pages/notification_module/button_trail_action/new_follow_action_button.dart';
import 'package:flutter/material.dart';

class NotificationActionButton extends StatelessWidget {
  const NotificationActionButton({
    super.key,
    required this.notification,
  });

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final AppNotTypes? notificationType = Utils.enumFromString<AppNotTypes>(
      AppNotTypes.values,
      notification.notificationType ?? '',
    );
    switch (notificationType) {
      case AppNotTypes.relation:
        {
          final type = Utils.enumFromString<RelationNotTypes>(
            RelationNotTypes.values,
            notification.type ?? '',
          );
          switch (type) {
            case RelationNotTypes.friendRequest:
              return FriendRequestActionButton(notification: notification);
            case RelationNotTypes.newFollow:
              return NewFollowActionButton(notification: notification);
            case RelationNotTypes.friendRequestAccepted:
              return const SizedBox();

            case null:
              return const SizedBox();
          }
        }
      case AppNotTypes.message:
        return const SizedBox();
      case AppNotTypes.orderEvent:
        return const SizedBox();
      case AppNotTypes.translatorCall:
        return const SizedBox();
      case AppNotTypes.post:
        return const SizedBox();
      case AppNotTypes.swap:
        return const SizedBox();

      case null:
        return const SizedBox();
    }
  }
}
