import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/swap_it_app/new_match_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/ui/pages/client_order_events_page.dart';
import 'package:fibali/ui/pages/my_stores/seller_orders/seller_order_events_page.dart';
import 'package:fibali/ui/pages/notification_module/button_trail_action/notification_action_button.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationTile extends StatefulWidget {
  final AppNotification notification;
  final String otherUserID;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.otherUserID,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  bool get isNotSeen => widget.notification.isSeen?[_currentUser?.uid] == false;

  late AppNotTypes? notificationType = Utils.enumFromString<AppNotTypes>(
    AppNotTypes.values,
    widget.notification.notificationType ?? '',
  );

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: TextButtonThemeData(
          style: TextButton.styleFrom(textStyle: const TextStyle(fontWeight: FontWeight.bold))),
      child: Row(
        children: [
          Flexible(
            child: ListTile(
              onTap: () async {
                AppNotification.ref(userID: _currentUser!.uid)
                    .doc(widget.notification.notificationID)
                    .update({
                  AppNotLabels.isSeen.name: {_currentUser!.uid: true},
                });

                switch (notificationType) {
                  case AppNotTypes.relation:
                    UserProfilePage.showPage(userID: widget.notification.senderID!);
                    break;
                  case AppNotTypes.swap:
                    {
                      final type = Utils.enumFromString<SwapNotTypes>(
                        SwapNotTypes.values,
                        widget.notification.type ?? '',
                      );
                      if (type == SwapNotTypes.newMatch) {
                        if (widget.notification.senderID is String &&
                            widget.notification.receiverID is String) {
                          showNewMatchPage(
                            currentUser: _currentUser!,
                            otherUserID: _currentUser!.uid == widget.notification.senderID
                                ? widget.notification.receiverID!
                                : widget.notification.senderID!,
                          );
                        }
                        if (type == SwapNotTypes.newSwapItemLike) {
                          SwapItemPage.showPage(
                            swapItemID: widget.notification.itemID,
                            swapItem: null,
                            heroTag: null,
                          );
                        }
                        if (type == SwapNotTypes.newSwapItemReview) {
                          SwapItemPage.showPage(
                            swapItemID: widget.notification.itemID,
                            swapItem: null,
                            heroTag: null,
                          );
                        }
                      }
                      break;
                    }
                  case AppNotTypes.post:
                    {
                      final type = Utils.enumFromString<PostNotTypes>(
                        PostNotTypes.values,
                        widget.notification.type ?? '',
                      );

                      switch (type) {
                        case PostNotTypes.newPostComment:
                          PostPage.show(
                            heroTag: null,
                            post: null,
                            postID: widget.notification.postID!,
                          );
                          break;
                        case PostNotTypes.newPostLike:
                          PostPage.show(
                            heroTag: null,
                            post: null,
                            postID: widget.notification.postID!,
                          );
                          break;
                        case PostNotTypes.newPost:
                          PostPage.show(
                            heroTag: null,
                            post: null,
                            postID: widget.notification.postID!,
                          );
                          break;
                        case PostNotTypes.newCommentReply:
                          PostPage.show(
                            heroTag: null,
                            post: null,
                            postID: widget.notification.postID!,
                          );
                          break;

                        case null:
                          break;
                      }

                      break;
                    }
                  case AppNotTypes.message:
                    // TODO: Handle this case.
                    break;
                  case AppNotTypes.orderEvent:
                    final orderType = Utils.enumFromString<OrEvNotTypes>(
                        OrEvNotTypes.values, widget.notification.type);

                    switch (orderType) {
                      case null:
                      // Seller related order events
                      case OrEvNotTypes.newOrder:
                        SellerOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.remindSeller:
                        SellerOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.orderReceived:
                        SellerOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.refundApplication:
                        SellerOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.addReview:
                        SellerOrderEventsPage.show(orderID: widget.notification.orderID!);

                      // Client related order events
                      case OrEvNotTypes.itemPackaged:
                        ClientOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.packageSent:
                        ClientOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.confirmOrder:
                        ClientOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.acceptRefund:
                        ClientOrderEventsPage.show(orderID: widget.notification.orderID!);
                      case OrEvNotTypes.declineRefund:
                        ClientOrderEventsPage.show(orderID: widget.notification.orderID!);
                    }

                    break;
                  case AppNotTypes.translatorCall:
                    // TODO: Handle this case.

                    break;
                  case null:
                }
              },
              tileColor: isNotSeen ? Colors.white30 : Colors.transparent,
              title: Text(
                '${RCCubit.instance.getCloudText(context, widget.notification.type ?? '')} ${RCCubit.instance.getText(R.from).toLowerCase()} ${widget.notification.senderName ?? ''} ',
                maxLines: 2,
                style: TextStyle(
                  fontWeight: isNotSeen ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              dense: true,
              leading: bd.Badge(
                position: bd.BadgePosition.topEnd(end: -4, top: -4),
                showBadge: isNotSeen,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: PhotoWidgetNetwork(
                    label: Utils.getInitial(widget.notification.senderName),
                    photoUrl: widget.notification.senderPhoto,
                    boxShape: BoxShape.circle,
                  ),
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(child: buildTileContent()),
                  if (notificationType != null)
                    widget.notification.timestamp != null
                        ? Text(
                            timeago.format(widget.notification.timestamp!.toDate()),
                            style: const TextStyle(color: Colors.grey),
                          )
                        : const Text(''),
                ],
              ),
            ),
          ),
          if (notificationType != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NotificationActionButton(notification: widget.notification),
            ),
        ],
      ),
    );
  }

  Widget buildTileContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.notification.description ?? '',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isNotSeen ? Colors.grey.shade400 : Colors.grey.shade400,
            fontStyle: isNotSeen ? FontStyle.italic : FontStyle.normal,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 10, child: VerticalDivider()),
      ],
    );
  }
}
