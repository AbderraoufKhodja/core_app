import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/d_l_params.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/swap_it_app/new_match_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/repositories/chat_get_snack_bar.dart';
import 'package:fibali/repositories/notifications_repository.dart';
import 'package:fibali/ui/pages/item_page.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/ui/pages/view_history/posts_history_view_tab.dart';
import 'package:fibali/ui/widgets/blurred_container.dart';
import 'package:fibali/ui/widgets/client_order_card.dart';
import 'package:fibali/ui/widgets/stf_check_box.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CloudMessagingRepository {
  final _fcm = FirebaseMessaging.instance;

  Future<void> initFCM(context, {required AppUser? currentUser}) async {
    await firebaseCloudMessagePermissionListener(
      context,
      currentUser: currentUser,
    );

    // It is assumed that all messages contain a data field with the key 'type'
    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await _fcm.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      handleMessage(
        codedJson: initialMessage.data['json'],
        currentUser: currentUser,
      );
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (remoteMessage) {
        debugPrint('Receive open app: $remoteMessage ');
        debugPrint('InOpenAppNotifyBody ${remoteMessage.data['body'].toString()}');
      },
    );

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Got a message whilst in the foreground!');
      handleMessage(
        codedJson: message.data['json'],
        currentUser: currentUser,
      );
    });
  }

  Future<void> handleDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen(handleDynamicLink);

    // Get any initial links
    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      FAC.logEvent(FAEvent.handle_initial_dynamic_link);
      handleDynamicLink(initialLink);
    }
  }

  void handleDynamicLink(dynamicLinkData) async {
    FAC.logEvent(FAEvent.handle_dynamic_link);
    final deepLink = dynamicLinkData.link;
    // Example of using the dynamic link to push the user to a different screen
    final dLType = Utils.enumFromString<DLTypes>(DLTypes.values, deepLink.path.substring(1));

    try {
      switch (dLType) {
        case DLTypes.post:
          final linkPost = Post.fromFirestore(deepLink.queryParameters);

          final postDoc = await Post.ref.doc(linkPost.postID).get();
          final post = postDoc.data();

          if (post != null) {
            PostPage.show(
              post: post,
              heroTag: const Uuid().v1(),
            );
          }

          break;
        case DLTypes.shoppingItem:
          final linkShoppingItem = Item.fromFirestore(deepLink.queryParameters);

          final itemDoc = await Item.ref.doc(linkShoppingItem.itemID).get();
          final item = itemDoc.data();

          if (item != null) {
            showItemPage(
              itemID: item.itemID!,
              storeID: item.storeID!,
              photo: item.photoUrls?[0],
            );
          }

          break;
        case DLTypes.app:
          // TODO: Handle this case.
          break;
        case DLTypes.swapItem:
          final linkShoppingItem = SwapItem.fromFirestore(deepLink.queryParameters);

          final itemDoc = await SwapItem.ref.doc(linkShoppingItem.itemID).get();
          final item = itemDoc.data();

          if (item != null) {
            SwapItemPage.showPage(
              heroTag: null,
              swapItem: item,
            );
          }
          break;
        case null:
          break;
      }
    } catch (error) {}
  }

  /// Get the token, save it to the database for current user
  Future<void> _saveDeviceToken({required AppUser currentUser}) async {
    // Get the token for this device
    String? fcmToken;
    String? deviceID;
    Map<String, dynamic>? allInfo;

    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        // import 'dart:io'
        // INFO: Device ID can't have "." in it's name $.replaceAll('.', '_')
        final iosDeviceInfo = await deviceInfo.iosInfo;
        deviceID = iosDeviceInfo.identifierForVendor?.replaceAll('.', '_'); // unique ID on iOS
      } else if (Platform.isAndroid) {
        final androidDeviceInfo = await deviceInfo.androidInfo;
        deviceID = androidDeviceInfo.id.replaceAll('.', '_'); // unique ID on Android
      }
      allInfo = await deviceInfo.deviceInfo.then((value) => value.data);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (deviceID == null) return;

    // TODO: this optimization needs to checked
    // final lastTokenTimestamp =
    // currentUser.devices?[deviceID]?[DeviceParameters.lastTokenTimestamp.name];
    // if (lastTokenTimestamp is Timestamp) {
    //   final durationSinceLastTokenGeneration = Timestamp
    //       .now()
    //       .seconds - lastTokenTimestamp.seconds;
    //   final isOverdue = durationSinceLastTokenGeneration > 7 * 24 * 60 * 60;
    //   if (isOverdue) {
    //     try {
    //       if (kIsWeb) {
    //         fcmToken = await _fcm.getToken(vapidKey: kVapidKey);
    //       } else {
    //         fcmToken = await _fcm.getToken();
    //       }
    //     } catch (e) {
    //       debugPrint(e.toString());
    //     }
    //   }
    // }

    try {
      if (kIsWeb) {
        fcmToken = await _fcm.getToken(vapidKey: kVapidKey);
      } else {
        fcmToken = await _fcm.getToken();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // Save it to Firestore
    final ref = AppUser.ref.doc(currentUser.uid);
    final fieldName = '${AULabels.devices.name}.$deviceID';

    await ref.update({
      '$fieldName.${DeviceParameters.deviceID.name}': deviceID,
      '$fieldName.${DeviceParameters.data.name}': allInfo,
      '$fieldName.${DeviceParameters.isLogged.name}': true,
      if (fcmToken != null) '$fieldName.${DeviceParameters.token.name}': fcmToken,
      if (fcmToken != null)
        '$fieldName.${DeviceParameters.lastTokenTimestamp.name}': FieldValue.serverTimestamp(),
    });
  }

  Future<void>? subscribeToFeedsTopic() {
    // Subscribe the user to a topic
    if (!kIsWeb) {
      return _fcm.subscribeToTopic('feeds');
    }
    return null;
  }

  static void handleMessage({
    required String codedJson,
    required AppUser? currentUser,
  }) async {
    FAC.logEvent(FAEvent.handle_received_notification);
    final notification = AppNotification.fromFirestore(jsonDecode(codedJson));

    if (currentUser?.uid == notification.receiverID && notification.receiverID != null) {
      final prefs = await SharedPreferences.getInstance();

      switch (
          Utils.enumFromString<AppNotTypes>(AppNotTypes.values, notification.notificationType!)) {
        case AppNotTypes.message:
          switch (Utils.enumFromString<MessageTypes>(MessageTypes.values, notification.type!)) {
            case MessageTypes.photo:
              // TODO: Handle this case.
              showMessageNotificationSnackBar(notification, prefs, currentUser);
              break;
            case MessageTypes.text:
              // TODO: Handle this case.
              showMessageNotificationSnackBar(notification, prefs, currentUser);
              break;
            case MessageTypes.location:
              // TODO: Handle this case.
              showMessageNotificationSnackBar(notification, prefs, currentUser);
              break;
            case MessageTypes.newSwap:
              // TODO: Handle this case.
              showMessageNotificationSnackBar(notification, prefs, currentUser);
              break;
            case MessageTypes.swapAccepted:
              // TODO: Handle this case.
              showMessageNotificationSnackBar(notification, prefs, currentUser);
              break;
            case MessageTypes.call:
              // TODO: Handle this case.
              break;
            case null:
              break;
          }

          break;
        case AppNotTypes.orderEvent:
          if (notification.orderID is String) {
            final orderID = notification.orderID as String;

            ShoppingOrder.ref.doc(orderID).get().then(
              (doc) {
                if (doc.exists) {
                  final order = doc.data()!;
                  if (order.isValid()) {
                    Get.rawSnackbar(
                      backgroundColor: Colors.black45,
                      messageText: BlurredContainer(
                          child: currentUser?.uid == order.clientID
                              ? ClientOrderCard(
                                  order: order,
                                  color: Colors.transparent,
                                )
                              : const SizedBox()),
                      animationDuration: const Duration(milliseconds: 800),
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                }
              },
            );
          }
          break;
        case AppNotTypes.translatorCall:
          // final title = data['title'];
          // final body = data['body'];
          // //Foreground Msg
          // debugPrint(data.toString());
          // debugPrint('callDataFromNotify $body');
          // final bodyJson = jsonDecode(body.toString());

          // int notificationId = Random().nextInt(1000);
          // var ios = const DarwinNotificationDetails();
          // var platform = NotificationDetails(
          //   android: NotificationsRepository.callChannel,
          //   iOS: ios,
          // );
          // await NotificationsRepository.flutterLocalNotificationsPlugin.show(
          //   notificationId,
          //   '📞Ringing...',
          //   '${CallModel.fromFirestore(bodyJson).callerName} is calling you',
          //   platform,
          //   payload: body,
          // );

          // await Future.delayed(const Duration(seconds: callDurationInSec), () {
          //   NotificationsRepository.flutterLocalNotificationsPlugin
          //       .cancel(notificationId)
          //       .then((value) {
          //     showMissedCallNotification(
          //       senderName: bodyJson['sender']['full_name'],
          //     );
          //   });
          // });
          break;

        case AppNotTypes.swap:
          {
            final type = Utils.enumFromString<SwapNotTypes>(
              SwapNotTypes.values,
              notification.type ?? '',
            );
            if (type == SwapNotTypes.newMatch) {
              if (notification.senderID is String && notification.receiverID is String) {
                showNewMatchPage(
                  currentUser: currentUser!,
                  otherUserID: currentUser.uid == notification.senderID
                      ? notification.receiverID!
                      : notification.senderID!,
                );
              }
              if (type == SwapNotTypes.newSwapItemLike) {
                // TODO: Handle this case.
              }
              if (type == SwapNotTypes.newSwapItemReview) {
                // TODO: Handle this case.
              }
            }
          }
          break;

        case AppNotTypes.relation:
          // TODO: Handle this case.
          break;
        case AppNotTypes.post:
          {
            final type = Utils.enumFromString<PostNotTypes>(
              PostNotTypes.values,
              notification.type ?? '',
            );
            if (notification.postID != null) {
              switch (type) {
                case PostNotTypes.newPostComment:
                  showCommentSnackBar(notification);
                  break;
                case PostNotTypes.newPostLike:
                  showPostTileSnackBar(prefs, notification);
                  break;
                case PostNotTypes.newPost:
                  showPostTileSnackBar(prefs, notification);
                  break;
                case PostNotTypes.newCommentReply:
                  showCommentSnackBar(notification);
                  break;
                case null:
                  break;
              }
            }
          }
          break;

        case null:
          // TODO: Handle this case.
          break;
      }
    }
  }

  static void showMessageNotificationSnackBar(
    AppNotification notification,
    SharedPreferences prefs,
    AppUser? currentUser,
  ) {
    if (notification.chatID != null && notification.senderName != null) {
      final currentChatID = prefs.getString("currentChatID");

      if (currentChatID != notification.chatID) {
        final String chatID = notification.chatID!;

        FirebaseFirestore.instance.collection(chatsCollection).doc(chatID).get().then(
          (doc) {
            if (doc.exists) {
              final chat = Chat.fromFirestore(doc.data()!);
              final usersID = chat.usersID as List<dynamic>?;

              final otherUserID = usersID?.firstWhere(
                (id) => id != currentUser!.uid,
                orElse: () => currentUser!.uid,
              );

              final otherUserName =
                  chat.senderID == otherUserID ? chat.senderName! : chat.receiverName!;

              final otherUserPhoto =
                  chat.senderID == otherUserID ? chat.senderPhoto : chat.receiverPhoto;

              if (otherUserID != null) {
                if (chat.isValid()) {
                  Get.showSnackbar(GetSnackBar(
                    onTap: (snackBar) {
                      showMessagingPage(
                        type: Chat.chatTypeFromString(name: chat.type),
                        chatID: chat.chatID!,
                        otherUserID: otherUserID,
                      );
                    },
                    isDismissible: true,
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    title: otherUserName,
                    mainButton: PhotoWidgetNetwork(
                      label: Utils.getInitial(otherUserName),
                      width: 50,
                      height: 50,
                      photoUrl: otherUserPhoto,
                      boxShape: BoxShape.circle,
                    ),
                    messageText: MessageText(chat: chat),
                  )
                      // snackPosition: widget.snackPosition,
                      // title: widget.title,
                      // messageText: widget.messageText,
                      // duration: widget.duration,
                      // onTap: widget.onTap,
                      // icon: widget.icon,
                      // margin: widget.margin,
                      );
                }
              }
            }
          },
        );
      }
    }
  }

  static void showCommentSnackBar(AppNotification notification) {
    Get.rawSnackbar(
      backgroundColor: Colors.black45,
      messageText: BlurredContainer(
        child: GestureDetector(
            onTap: () {
              EasyLoading.show();
              Post.ref.doc(notification.postID!).get().then((post) {
                if (post.data()?.isValid() == true) {
                  final heroTag = const Uuid().v4();
                  PostPage.show(
                    post: post.data()!,
                    heroTag: heroTag,
                  );
                }
              }).whenComplete(() => EasyLoading.dismiss());
            },
            child: ListTile(
              title: Text(
                notification.senderName ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                notification.text ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            )),
      ),
      onTap: (_) => Get.closeCurrentSnackbar(),
      animationDuration: const Duration(milliseconds: 800),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showPostTileSnackBar(SharedPreferences prefs, AppNotification notification) {
    final currentPostID = prefs.getString("postID");

    if (currentPostID != notification.postID) {
      Post.ref.doc(notification.postID!).get().then(
        (doc) {
          if (doc.exists) {
            final post = doc.data()!;

            if (post.isValid()) {
              Get.rawSnackbar(
                backgroundColor: Colors.black45,
                messageText: BlurredContainer(
                  child: HorizontalPostCard(
                    post: post,
                    isShimmer: false,
                  ),
                ),
                onTap: (_) => Get.closeCurrentSnackbar(),
                animationDuration: const Duration(milliseconds: 800),
                snackPosition: SnackPosition.TOP,
              );
            }
          }
        },
      );
    }
  }

  String inCaps(String str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '';

  static void showMissedCallNotification({required String senderName}) async {
    final notificationId = Random().nextInt(1000);
    const ios = DarwinNotificationDetails();
    final platform = NotificationDetails(
      android: NotificationsRepository.normalChannel,
      iOS: ios,
    );
    await NotificationsRepository.flutterLocalNotificationsPlugin.show(
      notificationId,
      '📞Missed Call',
      'You have missed call from $senderName',
      platform,
      payload: 'missedCall',
    );
  }

  Future<void> firebaseCloudMessagePermissionListener(
    BuildContext context, {
    required AppUser? currentUser,
  }) async {
    if (currentUser != null) {
      final notificationSettings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
        _saveDeviceToken(currentUser: currentUser);
        debugPrint('User granted permission');
      } else if (notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        final requestNotify = BlocProvider.of<SettingsCubit>(context).state.requestNotifyPermission;

        final status = await Permission.notification.request();
        if (status.isDenied == true && requestNotify == true) {
          await Get.dialog(
            Builder(builder: (context) {
              return AlertDialog(
                content: const Text('Notification disabled'),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  Row(
                    children: [
                      STFCheckBox(requestPermission: requestNotify),
                      TextButton(
                        child: Text(RCCubit.instance.getText(R.enable)),
                        onPressed: () => openAppSettings(),
                      ),
                    ],
                  ),
                ],
              );
            }),
          );
        }
        debugPrint('User declined or has not accepted permission');
      }
    }
  }
}

@pragma('vm:entry-point')
void onDidReceiveLocalNotification({
  required int? id,
  required String? title,
  required String? body,
  required String? payload,
}) {
  Get.dialog(
    CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('OK'),
          onPressed: () => Get.back(),
        )
      ],
    ),
  );
}
