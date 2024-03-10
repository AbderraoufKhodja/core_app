import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/ui/pages/notification_module/notifications_page.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

/// `NotificationBellIcon` is a stateless widget that represents a notification bell icon in the application.
/// It uses a `StreamBuilder` to listen for changes in the `AppNotification` collection in the database.
///
/// The `NotificationBellIcon` widget shows a badge if there are any unseen notifications for the current user.
/// The badge is a small red circle that appears at the top end of the notification bell icon.
///
/// Constructors:
/// `NotificationBellIcon({Key? key})` : Here, `key` is the identifier for this widget in the widget tree.
///
/// Important fields:
/// `currentUser` : Represents the current user of the application. It is of type `AppUser`.
///
/// Important methods:
/// `build(BuildContext context)` : This method describes the part of the user interface represented by this widget.
///
/// Usage:
/// ```dart
/// NotificationBellIcon()
/// ```
///
/// This will create a notification bell icon that shows a badge for unseen notifications.

class NotificationBellIcon extends StatelessWidget {
  const NotificationBellIcon({super.key});
  @override
  Widget build(BuildContext context) {
    final AppUser? currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return StreamBuilder<QuerySnapshot<AppNotification>>(
      stream: AppNotification.ref(userID: currentUser!.uid)
          .where('${AppNotLabels.isSeen.name}.${currentUser.uid}', isEqualTo: false)
          .orderBy(AppNotLabels.timestamp.name, descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        return Badge(
          showBadge: (snapshot.data?.docs.length ?? 0) > 0,
          badgeContent: const CircleAvatar(
            radius: 4,
            backgroundColor: Colors.redAccent,
            child: SizedBox(),
          ),
          badgeStyle: const BadgeStyle(
            shape: BadgeShape.circle,
            padding: EdgeInsets.all(0),
          ),
          position: BadgePosition.topEnd(end: 3, top: 0),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => NotificationsPage.show(),
              child: const Iconify(Bx.bxs_bell, size: 30, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
